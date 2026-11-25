"""Create or render locally timed lyrics and karaoke videos."""
import argparse
from difflib import SequenceMatcher
import json
import math
import os
from pathlib import Path
import re
import subprocess
from tempfile import TemporaryDirectory
import unicodedata

ROOT = Path(__file__).resolve().parents[2]
BIN = ROOT / "tools" / "ffmpeg" / "bin"
CAPTIONING = ROOT / "tools" / "captioning"
WHISPER = CAPTIONING / "bin" / "whisper-bin-x64-b5454" / "Release" / "whisper-cli.exe"
PRESETS = ROOT / "assets" / "text" / "styles" / "lyrics-video" / "presets.json"

STAMP = r"\d+:[0-5]\d(?:[.,]\d{1,3})?"
LINE_TAG = re.compile(rf"\[({STAMP})\]")
WORD_TAG = re.compile(rf"<({STAMP})>")
WORD = re.compile(r"[^\W_]+(?:['’][^\W_]+)*")


def run(args, **kwargs):
    subprocess.run([str(arg) for arg in args], check=True, **kwargs)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def new_path(path, suffix):
    if path.suffix.lower() != suffix or path.exists():
        raise ValueError(f"Choose a new {suffix} output: {path}")
    return path


def write_new(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("x", encoding="utf-8") as stream:
        stream.write(content)


def seconds(tag):
    minutes, secs = tag.replace(",", ".").split(":")
    return int(minutes) * 60 + float(secs)


def lrc_time(value):
    minutes, ms = divmod(round(value * 1000), 60000)
    return f"{minutes:02d}:{ms / 1000:06.3f}"


def ass_time(value):
    hs, centis = divmod(round(value * 100), 360000)
    mins, centis = divmod(centis, 6000)
    secs, centis = divmod(centis, 100)
    return f"{hs}:{mins:02d}:{secs:02d}.{centis:02d}"


def read_lrc(path):
    rows = []
    offset = 0
    for number, line in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        remaining = line.strip()
        if not remaining:
            continue
        metadata = re.fullmatch(r"\[([A-Za-z]+):(.*)\]", remaining)
        if metadata:
            if metadata[1].casefold() == "offset":
                offset = int(metadata[2]) / 1000
            continue
        starts = []
        while match := LINE_TAG.match(remaining):
            starts.append(seconds(match[1]))
            remaining = remaining[match.end():]
        if not starts:
            raise ValueError(f"Missing lyric timestamp at line {number}.")
        pieces = WORD_TAG.split(remaining)
        if len(pieces) == 1:
            rows.extend((start, [(start, remaining.strip())], None, False) for start in starts)
            continue
        if len(starts) != 1 or pieces[0].strip():
            raise ValueError(f"Use one line timestamp and tag each word at line {number}.")
        tags = [(seconds(t), text) for t, text in zip(pieces[1::2], pieces[2::2])]
        end = tags.pop()[0] if not tags[-1][1].strip() else None
        if not tags or any(not text.strip() for _, text in tags):
            raise ValueError(f"Missing lyric word at line {number}.")
        if (tags[0][0] < starts[0] or any(b[0] <= a[0] for a, b in zip(tags, tags[1:])) or
                end is not None and end <= tags[-1][0]):
            raise ValueError(f"Word timestamps must increase within line {number}.")
        rows.append((starts[0], tags, end, True))
    shifted = sorted(
        (max(0, start + offset), [(max(0, t + offset), text) for t, text in tags],
         None if end is None else max(0, end + offset), word_timed)
        for start, tags, end, word_timed in rows
    )
    if not shifted or not any(text.strip() for _, tags, _, _ in shifted for _, text in tags):
        raise ValueError("No timed lyrics were found.")
    if any(a[0] == b[0] for a, b in zip(shifted, shifted[1:])):
        raise ValueError("Each lyric line must start at a unique time.")
    return shifted


def color(hex_rgb):
    rgb = hex_rgb.removeprefix("#")
    if not re.fullmatch(r"[0-9a-fA-F]{6}", rgb):
        raise ValueError(f"Invalid color: {hex_rgb}")
    return rgb[4:6] + rgb[2:4] + rgb[0:2]


def ass_text(text, uppercase):
    text = text.upper() if uppercase else text
    return text.translate(str.maketrans({"\\": "＼", "{": "｛", "}": "｝"}))


def create_ass(rows, style, width, height, duration, max_hold):
    scale = min(width / 1080, height / 900)
    size = max(10, round(style["size"] * scale))
    outline, shadow = (round(style[key] * scale, 1) for key in ("outline", "shadow"))
    margin = max(10, round(width * 0.075))
    base, accent, edge = (color(style[key]) for key in ("base", "accent", "edge"))
    bold = -1 if style.get("bold", True) else 0
    italic = -1 if style.get("italic") else 0
    placement = round(height * style["placement"] / 100)
    out = [
        "[Script Info]", "ScriptType: v4.00+", f"PlayResX: {width}", f"PlayResY: {height}",
        "WrapStyle: 0", "ScaledBorderAndShadow: yes", "",
        "[V4+ Styles]",
        "Format: Name,Fontname,Fontsize,PrimaryColour,SecondaryColour,OutlineColour,BackColour,Bold,Italic,Underline,StrikeOut,ScaleX,ScaleY,Spacing,Angle,BorderStyle,Outline,Shadow,Alignment,MarginL,MarginR,MarginV,Encoding",
        f"Style: Lyrics,{style['font']},{size},&H00{base},&H00{accent},&H00{edge},&H68000000,{bold},{italic},0,0,100,100,0,0,1,{outline},{shadow},5,{margin},{margin},0,1",
        "", "[Events]", "Format: Layer,Start,End,Style,Name,MarginL,MarginR,MarginV,Effect,Text",
    ]
    count = 0

    def event(start, end, text):
        nonlocal count
        if ass_time(start) == ass_time(end) or start >= end:
            return
        place = fr"{{\pos({width // 2},{placement})}}"
        out.append(f"Dialogue: 0,{ass_time(start)},{ass_time(end)},Lyrics,,0,0,0,,{place}{text}")
        count += 1

    for i, (start, tags, explicit_end, word_timed) in enumerate(rows):
        text = [ass_text(word, style.get("uppercase", False)) for _, word in tags]
        if not any(word.strip() for word in text) or start >= duration:
            continue
        next_start = rows[i + 1][0] if i + 1 < len(rows) else duration
        end = min(next_start, duration, explicit_end if explicit_end is not None else
                  max(start + max_hold, tags[-1][0] + 0.7))
        if not word_timed:
            event(start, end, text[0])
            continue
        event(start, min(end, tags[0][0]), "".join(text))
        for index, (at, _) in enumerate(tags):
            until = min(end, tags[index + 1][0]) if index + 1 < len(tags) else end
            if until <= at:
                continue
            current = []
            for j, word in enumerate(text):
                active = j <= index if style["highlight"] == "sung" else j == index
                paint = accent if active else base
                current.append(fr"{{\1c&H{paint}&}}{word}")
            event(at, until, "".join(current))
    if not count:
        raise ValueError("No timed lyrics fall inside this audio.")
    return "\n".join(out) + "\n"


def probe_audio(source):
    data = json.loads(subprocess.check_output([
        str(BIN / "ffprobe.exe"), "-v", "error", "-select_streams", "a:0",
        "-show_entries", "stream=duration:format=duration", "-of", "json", str(source),
    ]))
    if not data.get("streams"):
        raise ValueError("Input needs an audio track.")
    stream_duration = data["streams"][0].get("duration")
    duration = float(stream_duration if stream_duration not in (None, "N/A") else data["format"]["duration"])
    if not math.isfinite(duration) or duration <= 0:
        raise ValueError("Could not read audio duration.")
    return duration


def render(args, style):
    new_path(args.output, ".mp4")
    editable = args.output.with_suffix(".ass")
    new_path(editable, ".ass")
    if not args.audio.is_file() or not args.lrc.is_file():
        raise ValueError("Provide an existing local audio file and timed LRC.")
    if args.background and (not args.background.is_file() or
                            args.background.suffix.lower() not in {".jpg", ".jpeg", ".png", ".webp"}):
        raise ValueError("Background must be a local JPEG, PNG, or WebP.")
    w, h, fps = args.width, args.height, args.fps
    if not (all(16 <= n <= 4096 and n % 2 == 0 for n in (w, h)) and 1 <= fps <= 120 and
            math.isfinite(args.max_hold) and args.max_hold > 0):
        raise ValueError("Use even dimensions, a positive hold, and FPS from 1 to 120.")
    duration = probe_audio(args.audio)
    ass = create_ass(read_lrc(args.lrc), style, w, h, duration, args.max_hold)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(prefix=".lyrics-render-", dir=args.output.parent) as temporary:
        directory = Path(temporary)
        (directory / "lyrics.ass").write_text(ass, encoding="utf-8")
        command = [BIN / "ffmpeg.exe", "-hide_banner", "-loglevel", "error", "-nostdin", "-n"]
        if args.background:
            command += ["-i", args.background]
        else:
            shade = style["background"].removeprefix("#")
            command += ["-f", "lavfi", "-i", f"color=0x{shade}:s={w}x{h}:r={fps}"]
        filters = (f"scale={w}:{h}:force_original_aspect_ratio=decrease:force_divisible_by=2,"
                   f"pad={w}:{h}:(ow-iw)/2:(oh-ih)/2,setsar=1")
        if args.background:
            filters += f",tpad=stop_mode=clone:stop_duration={duration:.6f},fps={fps}"
        filters += ",ass=lyrics.ass"
        run(command + [
            "-i", args.audio, "-map", "0:v:0", "-map", "1:a:0", "-vf", filters,
            "-t", f"{duration:.6f}", "-c:v", "libx264", "-preset", "fast", "-crf", "18",
            "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "192k", "-movflags", "+faststart",
            "render.mp4",
        ], cwd=directory)
        (directory / "render.mp4").rename(args.output)
        (directory / "lyrics.ass").rename(editable)
    print(args.output)
    print(editable)


def normalize(word):
    return unicodedata.normalize("NFKC", word).casefold().replace("’", "'")


def transcript_words(payload):
    if "words" in payload:
        rows = [(r["text"], float(r["start"]), float(r["end"])) for r in payload["words"]]
    else:
        rows = []
        for row in payload["transcription"]:
            marks = row.get("timestamps")
            if marks:
                def parse(t):
                    h, m, s = t.replace(",", ".").split(":")
                    return int(h) * 3600 + int(m) * 60 + float(s)
                begin, end = (parse(marks[key]) for key in ("from", "to"))
            else:
                begin, end = (row["offsets"][key] / 1000 for key in ("from", "to"))
            rows.append((row["text"], begin, end))
    words = []
    for text, begin, end in rows:
        tokens = WORD.findall(text)
        if len(tokens) == 1 and math.isfinite(begin) and math.isfinite(end) and 0 <= begin < end:
            words.append((normalize(tokens[0]), begin, end))
    return words


def align(args):
    new_path(args.output, ".lrc")
    report = args.output.with_suffix(".review.json")
    new_path(report, ".json")
    source_lines = [(i, line.strip()) for i, line in
                    enumerate(args.lyrics.read_text(encoding="utf-8-sig").splitlines(), 1) if line.strip()]
    if not source_lines:
        raise ValueError("Lyrics TXT has no lines.")
    if args.transcript:
        recognized = transcript_words(read_json(args.transcript))
    else:
        model = CAPTIONING / "models" / ("ggml-small.en.bin" if args.language == "en" else "ggml-small.bin")
        with TemporaryDirectory(prefix="local-lyrics-whisper-") as temporary:
            wav = Path(temporary) / "vocals.wav"
            stem = wav.with_suffix("")
            run([BIN / "ffmpeg.exe", "-v", "error", "-nostdin", "-i", args.audio, "-vn",
                 "-ac", 1, "-ar", 16000, "-c:a", "pcm_s16le", wav])
            run([WHISPER, "-m", model, "-f", wav, "-l", args.language, "-t", min(4, os.cpu_count() or 1),
                 "-ml", 1, "-sow", "-oj", "-of", stem], stdout=subprocess.DEVNULL)
            recognized = transcript_words(read_json(stem.with_suffix(".json")))
    if not recognized:
        raise ValueError("No usable word timestamps. Try a clean vocal stem or provide an LRC.")

    expected = [normalize(word.group()) for _, line in source_lines for word in WORD.finditer(line)]
    matcher = SequenceMatcher(None, expected, [word for word, _, _ in recognized], autojunk=False)
    mapping = {a + k: b + k for a, b, length in matcher.get_matching_blocks() for k in range(length)}
    index, last_end = 0, -1
    timed, missing = [], []
    for number, line in source_lines:
        words = list(WORD.finditer(line))
        hits = [mapping.get(index + k) for k in range(len(words))]
        index += len(words)
        if (not hits or None in hits or hits != list(range(hits[0], hits[0] + len(hits)))):
            missing.append({"line": number, "lyrics": line})
            continue
        times = [recognized[hit][1] for hit in hits]
        end = recognized[hits[-1]][2]
        if (times[0] < last_end or end <= times[-1] or
                any(after <= before for before, after in zip(times, times[1:]))):
            missing.append({"line": number, "lyrics": line})
            continue
        tagged = [f"<{lrc_time(at)}>{line[0 if k == 0 else words[k].start():words[k+1].start() if k+1 < len(words) else len(line)]}"
                  for k, at in enumerate(times)]
        timed.append(f"[{lrc_time(times[0])}]{''.join(tagged)}<{lrc_time(end)}>")
        last_end = end
    result = {"status": "draft", "matched_lines": len(timed), "total_lines": len(source_lines),
              "unmatched_lines": missing}
    write_new(report, json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    if not timed:
        raise ValueError(f"No full lines matched. Review {report} and supply corrected timings.")
    write_new(args.output, "\n".join(timed) + "\n")
    print(f"Draft: {len(timed)}/{len(source_lines)} lines matched. Review {report} against the music.")


def main():
    styles = read_json(PRESETS)["styles"]
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("styles", help="List the portable lyric styles.")
    timing = commands.add_parser("align", help="Suggest word timings for supplied lyrics.")
    video = commands.add_parser("render", help="Render timed lyrics over a still or solid background.")
    local = lambda value: Path(value).resolve()
    for command, source in ((timing, "lyrics"), (video, "lrc")):
        command.add_argument("audio", type=local)
        command.add_argument(source, type=local)
        command.add_argument("output", type=local)
    timing.add_argument("--transcript", type=local, help="Optional existing word-timed JSON.")
    timing.add_argument("--language", choices=["en", "tl", "auto"], default="auto")
    video.add_argument("--style", choices=styles, default="classic-videoke")
    video.add_argument("--background", type=local)
    video.add_argument("--width", type=int, default=1920)
    video.add_argument("--height", type=int, default=1080)
    video.add_argument("--fps", type=int, default=30)
    video.add_argument("--max-hold", type=float, default=8, help="Default maximum line hold in seconds.")
    args = parser.parse_args()
    try:
        if args.command == "styles":
            print("\n".join(styles))
        elif args.command == "align":
            if not args.audio.is_file():
                raise ValueError("Provide existing local song audio or a time-aligned vocal stem.")
            align(args)
        else:
            render(args, styles[args.style])
    except (OSError, ValueError, KeyError, TypeError, subprocess.CalledProcessError) as exc:
        parser.exit(1, f"Error: {exc}\n")


if __name__ == "__main__":
    main()
