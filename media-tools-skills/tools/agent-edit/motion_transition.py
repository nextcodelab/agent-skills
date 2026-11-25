"""Join two local scenes with a named motion transition."""
import argparse
import json
import math
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
BIN = ROOT / "tools" / "ffmpeg" / "bin"
PRESETS = ROOT / "assets" / "effects" / "presets" / "explainer-transitions.json"


def probe(source):
    info = json.loads(subprocess.check_output([
        str(BIN / "ffprobe.exe"), "-v", "error", "-show_streams", "-show_format",
        "-of", "json", str(source),
    ]))
    video = next((stream for stream in info["streams"] if stream["codec_type"] == "video"), None)
    if video is None:
        raise ValueError(f"No video stream in {source}")
    duration = float(video.get("duration") or info["format"]["duration"])
    if not math.isfinite(duration) or duration <= 0:
        raise ValueError(f"Could not determine video duration for {source}")
    audio = any(stream["codec_type"] == "audio" for stream in info["streams"])
    return duration, audio


def video_filters(width, height, fps):
    return (
        f"fps={fps},scale={width}:{height}:force_original_aspect_ratio=decrease:"
        f"force_divisible_by=2:reset_sar=1,pad={width}:{height}:(ow-iw)/2:(oh-ih)/2:black,"
        f"setsar=1,format=yuv444p,settb=1/{fps},setpts=PTS-STARTPTS"
    )


def scan_filter(cfg, width, height, fps, offset, window):
    x, y, w, h = window
    scan = min(cfg["scan_seconds"], offset)
    if scan <= 0:
        return ["[a0]null[a]"]
    start = offset - scan
    thickness = max(2, round(height / 480))
    bar_width = max(2, 2 * round(width * w / 2))
    top = round(height * y)
    travel = max(0, round(height * h) - thickness)
    return [
        f"color=c={cfg['scan_color']}:s={bar_width}x{thickness}:r={fps},format=yuv444p[scan]",
        f"[a0][scan]overlay=x={round(width * x)}:y='{top}+{travel}*(t-{start:.8f})/{scan:.8f}':"
        f"enable='gte(t,{start:.8f})*lt(t,{offset:.8f})':shortest=1:format=yuv444[a]",
    ]


def zoom_settle_filter(width, height, fps, zoom, seconds):
    frames = max(1, round(seconds * fps))
    amount = zoom - 1
    return (
        f",zoompan=z='1+{amount:.6f}*pow(max(0,1-on/{frames}),2)':"
        f"x='(iw-iw/zoom)/2':y='(ih-ih/zoom)/2':d=1:s={width}x{height}:fps={fps},"
        f"setsar=1,format=yuv444p,settb=1/{fps},setpts=PTS-STARTPTS"
    )


def audio_filter(index, duration, has_audio, label):
    source = f"[{index}:a:0]aresample=48000" if has_audio else "anullsrc=r=48000:cl=stereo"
    return (
        f"{source},aformat=sample_fmts=fltp:channel_layouts=stereo,"
        f"asetpts=PTS-STARTPTS,apad,atrim=duration={duration:.8f}[{label}]"
    )


def main():
    presets = json.loads(PRESETS.read_text(encoding="utf-8"))["presets"]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("outgoing", type=Path)
    parser.add_argument("incoming", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--preset", choices=presets, default="scan-slice")
    parser.add_argument("--seconds", type=float)
    parser.add_argument("--width", type=int, default=1080)
    parser.add_argument("--height", type=int, default=1920)
    parser.add_argument("--fps", type=int, default=30)
    parser.add_argument("--scan-window", type=float, nargs=4, metavar=("X", "Y", "W", "H"),
                        help="Normalized rectangle for the scan line on the outgoing card.")
    parser.add_argument("--narration", type=Path, help="Optional continuous audio file for the combined cut.")
    args = parser.parse_args()
    a, b, out = (path.resolve() for path in (args.outgoing, args.incoming, args.output))
    narration = args.narration.resolve() if args.narration else None
    if not a.is_file() or not b.is_file() or (narration and not narration.is_file()):
        parser.error("Provide existing local input files.")
    if out.suffix.lower() != ".mp4" or out.exists() or out in {a, b, narration}:
        parser.error("Choose a new .mp4 output path.")
    w, h, fps = args.width, args.height, args.fps
    if min(w, h) < 16 or w % 2 or h % 2 or not 1 <= fps <= 120:
        parser.error("Use even dimensions of at least 16 pixels and FPS between 1 and 120.")
    cfg = presets[args.preset]
    seconds = args.seconds if args.seconds is not None else cfg["seconds"]
    if not 0.04 <= seconds <= 4:
        parser.error("Use a transition duration between 0.04 and 4 seconds.")
    transition = max(1, round(seconds * fps)) / fps
    try:
        a_duration, a_audio = probe(a)
        b_duration, b_audio = probe(b)
        a_frames, b_frames = math.floor(a_duration * fps + 1e-5), math.floor(b_duration * fps + 1e-5)
        if min(a_frames, b_frames) / fps <= transition:
            raise ValueError("Both clips must be longer than the transition.")
        a_length, b_length = a_frames / fps, b_frames / fps
        offset = a_length - transition
        filters = video_filters(w, h, fps)
        incoming_filters = filters
        if "incoming_zoom" in cfg:
            incoming_filters += zoom_settle_filter(
                w, h, fps, cfg["incoming_zoom"], cfg["zoom_settle_seconds"]
            )
        graph = [f"[0:v:0]{filters},trim=end_frame={a_frames}[a0]",
                 f"[1:v:0]{incoming_filters},trim=end_frame={b_frames}[b]"]
        if args.preset == "scan-slice":
            window = args.scan_window or cfg["scan_window"]
            x, y, width, height = window
            if not (0 <= x < 1 and 0 <= y < 1 and 0 < width <= 1-x and 0 < height <= 1-y):
                raise ValueError("Scan window must fit inside the output canvas.")
            graph.extend(scan_filter(cfg, w, h, fps, offset, window))
        else:
            graph.append("[a0]null[a]")
        graph.append(f"[a][b]xfade=transition={cfg['xfade']}:duration={transition:.8f}:"
                     f"offset={offset:.8f},format=yuv420p[v]")
        cmd = [str(BIN / "ffmpeg.exe"), "-hide_banner", "-loglevel", "error", "-nostdin",
               "-n", "-i", str(a), "-i", str(b)]
        audio_args = []
        if narration:
            cmd.extend(["-i", str(narration)])
            audio_args = ["-map", "2:a:0", "-af", "apad"]
        elif a_audio or b_audio:
            graph.extend([audio_filter(0, a_length, a_audio, "aa"),
                          audio_filter(1, b_length, b_audio, "ba"),
                          f"[aa][ba]acrossfade=d={transition:.8f}[mix]"])
            audio_args = ["-map", "[mix]"]
        out.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(cmd + [
            "-filter_complex_threads", "1", "-filter_complex", ";".join(graph), "-map", "[v]",
            *audio_args, "-c:v", "libx264", "-preset", "fast", "-crf", "18",
            "-c:a", "aac", "-b:a", "192k", "-t", f"{offset + b_length:.8f}",
            "-movflags", "+faststart", str(out),
        ], check=True)
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as exc:
        parser.exit(1, f"Error: {exc}\n")
    print(out)


if __name__ == "__main__":
    main()
