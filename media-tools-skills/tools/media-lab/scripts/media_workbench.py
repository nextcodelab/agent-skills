#!/usr/bin/env python3
"""Portable, local FFmpeg workbench for common agent-led media edits."""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
FFMPEG = ROOT / "tools" / "ffmpeg" / "bin" / "ffmpeg.exe"
FFPROBE = ROOT / "tools" / "ffmpeg" / "bin" / "ffprobe.exe"


def run(args: list[str]) -> None:
    p = subprocess.run(args, text=True)
    if p.returncode:
        raise RuntimeError(f"Process exited with code {p.returncode}: {args[0]}")


def ffmpeg(args: list[str]) -> None:
    if not FFMPEG.is_file():
        raise FileNotFoundError(f"Bundled FFmpeg not found: {FFMPEG}")
    run([str(FFMPEG), "-hide_banner", "-nostdin", *args])


def output_args(dest: Path, overwrite: bool) -> list[str]:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and not overwrite:
        raise FileExistsError(f"Output exists; choose a new name or pass --overwrite: {dest}")
    return ["-y" if overwrite else "-n", str(dest)]


def probe(path: Path) -> None:
    if not FFPROBE.is_file():
        raise FileNotFoundError(f"Bundled ffprobe not found: {FFPROBE}")
    run([str(FFPROBE), "-v", "error", "-show_format", "-show_streams", "-of", "json", str(path)])


def extract_audio(a: argparse.Namespace) -> None:
    src, dst = a.input.resolve(), a.output.resolve()
    if not src.is_file():
        raise FileNotFoundError(src)
    args = ["-i", str(src), "-vn", "-map", "0:a:0"]
    if dst.suffix.lower() == ".wav":
        args += ["-c:a", "pcm_s24le", "-ar", str(a.sample_rate)]
    elif dst.suffix.lower() in {".m4a", ".aac"}:
        args += ["-c:a", "aac", "-b:a", a.bitrate]
    else:
        args += ["-c:a", "libmp3lame", "-b:a", a.bitrate]
    ffmpeg(args + output_args(dst, a.overwrite))


def audio_finish(a: argparse.Namespace) -> None:
    src, dst = a.input.resolve(), a.output.resolve()
    if not src.is_file():
        raise FileNotFoundError(src)
    chain = []
    if a.denoise:
        chain.append(f"afftdn=nf={a.noise_floor}:tn=1")
    if a.voice:
        chain += ["highpass=f=75", "lowpass=f=12000", "acompressor=threshold=0.12:ratio=2.5:attack=15:release=180:makeup=1"]
    if a.normalize:
        chain.append(f"loudnorm=I={a.target_lufs}:TP=-1.5:LRA=11")
    if a.fade_in > 0:
        chain.append(f"afade=t=in:st=0:d={a.fade_in}")
    if a.fade_out > 0:
        if a.duration <= 0:
            raise ValueError("--duration is required when using --fade-out")
        chain.append(f"afade=t=out:st={max(0, a.duration-a.fade_out)}:d={a.fade_out}")
    args = ["-i", str(src), "-vn"]
    if chain:
        args += ["-af", ",".join(chain)]
    if dst.suffix.lower() == ".mp3":
        args += ["-c:a", "libmp3lame", "-b:a", a.bitrate]
    elif dst.suffix.lower() == ".wav":
        args += ["-c:a", "pcm_s24le", "-ar", str(a.sample_rate)]
    else:
        args += ["-c:a", "aac", "-b:a", a.bitrate, "-ar", str(a.sample_rate)]
    ffmpeg(args + output_args(dst, a.overwrite))


def mix_audio(a: argparse.Namespace) -> None:
    video, bed, dst = a.video.resolve(), a.bed.resolve(), a.output.resolve()
    if not video.is_file() or not bed.is_file():
        raise FileNotFoundError(video if not video.is_file() else bed)
    # Original audio stays at its natural level; only the supplied bed is attenuated.
    graph = f"[1:a]volume={a.bed_volume},afade=t=in:st=0:d={a.fade_in},afade=t=out:st={max(0,a.duration-a.fade_out)}:d={a.fade_out}[bed];[0:a][bed]amix=inputs=2:duration=first:dropout_transition=2,alimiter=limit=0.95[a]"
    args = ["-i", str(video), "-stream_loop", "-1", "-i", str(bed), "-filter_complex", graph, "-map", "0:v:0", "-map", "[a]", "-c:v", "copy", "-c:a", "aac", "-b:a", a.bitrate, "-shortest", "-movflags", "+faststart"]
    ffmpeg(args + output_args(dst, a.overwrite))


def reframe(a: argparse.Namespace) -> None:
    src, dst = a.input.resolve(), a.output.resolve()
    if not src.is_file():
        raise FileNotFoundError(src)
    w, h = a.width, a.height
    if a.fit == "cover":
        vf = f"scale={w}:{h}:force_original_aspect_ratio=increase,crop={w}:{h}"
    else:
        vf = f"scale={w}:{h}:force_original_aspect_ratio=decrease,pad={w}:{h}:(ow-iw)/2:(oh-ih)/2:color=black"
    if a.look == "warm":
        vf += ",eq=saturation=1.08:contrast=1.03:brightness=0.01,colorbalance=rs=0.04:gs=0.01:bs=-0.03"
    elif a.look == "clean":
        vf += ",eq=saturation=1.03:contrast=1.02"
    if a.sharpen:
        vf += ",unsharp=5:5:0.45:3:3:0.0"
    if a.fps:
        vf += f",fps={a.fps}"
    args = ["-i", str(src), "-vf", vf, "-map", "0:v:0", "-map", "0:a?", "-c:v", "libx264", "-preset", a.preset, "-crf", str(a.crf), "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", a.bitrate, "-movflags", "+faststart"]
    ffmpeg(args + output_args(dst, a.overwrite))


def image_finish(a: argparse.Namespace) -> None:
    src, dst = a.input.resolve(), a.output.resolve()
    if not src.is_file():
        raise FileNotFoundError(src)
    vf = f"scale={a.width}:{a.height}:force_original_aspect_ratio={'increase' if a.fit == 'cover' else 'decrease'}"
    vf += f",{'crop='+str(a.width)+':'+str(a.height) if a.fit == 'cover' else 'pad='+str(a.width)+':'+str(a.height)+':(ow-iw)/2:(oh-ih)/2:color=black'}"
    if a.look == "warm":
        vf += ",eq=saturation=1.08:contrast=1.03:brightness=0.01,colorbalance=rs=0.04:gs=0.01:bs=-0.03"
    elif a.look == "clean":
        vf += ",eq=saturation=1.03:contrast=1.02"
    if a.sharpen:
        vf += ",unsharp=5:5:0.45:3:3:0.0"
    ffmpeg(["-i", str(src), "-vf", vf, "-frames:v", "1"] + output_args(dst, a.overwrite))


def parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Local agent-run editing helpers powered by the bundled FFmpeg; no service keys or uploads.")
    sub = p.add_subparsers(dest="action", required=True)
    q = sub.add_parser("probe", help="Print video/audio/image stream metadata"); q.add_argument("input", type=Path); q.set_defaults(fn=lambda x: probe(x.input.resolve()))
    q = sub.add_parser("extract-audio", help="Extract a video's audio to WAV, MP3, AAC, or M4A"); q.add_argument("input", type=Path); q.add_argument("output", type=Path); q.add_argument("--sample-rate", type=int, default=48000); q.add_argument("--bitrate", default="192k"); q.add_argument("--overwrite", action="store_true"); q.set_defaults(fn=extract_audio)
    q = sub.add_parser("audio-finish", help="Denoise, shape voice, normalize loudness, and fade a new audio copy"); q.add_argument("input", type=Path); q.add_argument("output", type=Path); q.add_argument("--denoise", action="store_true"); q.add_argument("--noise-floor", type=int, default=-25); q.add_argument("--voice", action="store_true"); q.add_argument("--normalize", action="store_true"); q.add_argument("--target-lufs", type=float, default=-16); q.add_argument("--fade-in", type=float, default=0); q.add_argument("--fade-out", type=float, default=0); q.add_argument("--duration", type=float, default=0); q.add_argument("--sample-rate", type=int, default=48000); q.add_argument("--bitrate", default="192k"); q.add_argument("--overwrite", action="store_true"); q.set_defaults(fn=audio_finish)
    q = sub.add_parser("mix-bed", help="Mix local music/SFX under a video's original audio"); q.add_argument("video", type=Path); q.add_argument("bed", type=Path); q.add_argument("output", type=Path); q.add_argument("--duration", type=float, required=True); q.add_argument("--bed-volume", type=float, default=0.12); q.add_argument("--fade-in", type=float, default=0.8); q.add_argument("--fade-out", type=float, default=1.2); q.add_argument("--bitrate", default="192k"); q.add_argument("--overwrite", action="store_true"); q.set_defaults(fn=mix_audio)
    q = sub.add_parser("reframe", help="Export clean portrait/square/landscape framing without a blurred canvas"); q.add_argument("input", type=Path); q.add_argument("output", type=Path); q.add_argument("--width", type=int, default=1080); q.add_argument("--height", type=int, default=1920); q.add_argument("--fit", choices=["cover", "contain"], default="cover"); q.add_argument("--look", choices=["none", "clean", "warm"], default="none"); q.add_argument("--sharpen", action="store_true"); q.add_argument("--fps", type=int, default=0); q.add_argument("--preset", choices=["ultrafast", "veryfast", "fast", "medium"], default="veryfast"); q.add_argument("--crf", type=int, default=18); q.add_argument("--bitrate", default="192k"); q.add_argument("--overwrite", action="store_true"); q.set_defaults(fn=reframe)
    q = sub.add_parser("image", help="Resize, crop/contain, and apply a restrained local image look"); q.add_argument("input", type=Path); q.add_argument("output", type=Path); q.add_argument("--width", type=int, default=1080); q.add_argument("--height", type=int, default=1920); q.add_argument("--fit", choices=["cover", "contain"], default="cover"); q.add_argument("--look", choices=["none", "clean", "warm"], default="none"); q.add_argument("--sharpen", action="store_true"); q.add_argument("--overwrite", action="store_true"); q.set_defaults(fn=image_finish)
    return p


if __name__ == "__main__":
    try:
        args = parser().parse_args(); args.fn(args)
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr); raise SystemExit(1)
