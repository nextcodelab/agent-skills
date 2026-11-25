"""Burn an opening hook into a finished clip and optionally export its first frame."""
import argparse
import math
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import textwrap

ROOT = Path(__file__).resolve().parents[2]
FFMPEG = ROOT / "tools" / "ffmpeg" / "bin" / "ffmpeg.exe"

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--text", required=True, help="Short editorial hook, ideally 4–8 words.")
    hold = parser.add_mutually_exclusive_group()
    hold.add_argument("--seconds", type=float, default=2.2)
    hold.add_argument("--full-length", action="store_true", help="Keep the headline visible for the entire clip.")
    parser.add_argument("--position", choices=["upper", "lower", "header"], default="upper",
                        help="Use header with footage already framed below a black top band.")
    parser.add_argument("--thumbnail", type=Path, help="Optional JPEG/PNG of the rendered opening frame.")
    args = parser.parse_args()
    source, output = args.source.resolve(), args.output.resolve()
    thumbnail = args.thumbnail.resolve() if args.thumbnail else None
    if not source.is_file() or output.suffix.lower() != ".mp4":
        parser.error("Provide an existing source and a new .mp4 output.")
    if thumbnail and thumbnail.suffix.lower() not in {".jpeg", ".jpg", ".png"}:
        parser.error("Thumbnail must end in .jpg, .jpeg, or .png.")
    if not math.isfinite(args.seconds) or not 0.25 <= args.seconds <= 10:
        parser.error("Choose a hook duration between 0.25 and 10 seconds.")
    words = " ".join(args.text.split())
    lines = textwrap.wrap(words, width=22, break_long_words=False, break_on_hyphens=False)
    if not lines or len(lines) > 3 or any(len(line) > 22 for line in lines):
        parser.error("Shorten the hook to at most three lines of 22 characters.")
    targets = [output] + ([thumbnail] if thumbnail else [])
    if len(set(targets)) != len(targets) or any(path == source or path.exists() for path in targets):
        parser.error("Each output must be a distinct new file.")
    for path in targets:
        path.parent.mkdir(parents=True, exist_ok=True)
    font = Path(os.environ.get("WINDIR", r"C:\Windows")) / "Fonts" / "arialbd.ttf"
    with tempfile.TemporaryDirectory(prefix="podcast-hook-") as work_dir:
        work = Path(work_dir)
        shutil.copyfile(font, work / "hook.ttf")
        (work / "hook.txt").write_text("\n".join(lines), encoding="utf-8")
        y = {"upper": "h*0.14", "lower": "h*0.70-th", "header": "h*0.108-th/2"}[args.position]
        fontsize = "min(w/30\\,h/24)" if args.position == "header" else "min(w/26\\,h/18)"
        box = "0" if args.position == "header" else "1"
        draw = (
            "drawtext=fontfile=hook.ttf:textfile=hook.txt:expansion=none:"
            f"fontsize={fontsize}:line_spacing=8:fontcolor=white:"
            f"box={box}:boxcolor=black@0.82:boxborderw=14:x=(w-tw)/2:y={y}"
        )
        if not args.full_length:
            draw += f":enable='lt(t,{args.seconds})'"
        cmd = [str(FFMPEG), "-hide_banner", "-loglevel", "error", "-nostdin", "-n"]
        subprocess.run(cmd + [
            "-i", str(source), "-map", "0:v:0", "-map", "0:a:0?",
            "-vf", f"setpts=PTS-STARTPTS,{draw}", "-c:v", "libx264",
            "-crf", "18", "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "192k",
            "-movflags", "+faststart", str(output),
        ], cwd=work, check=True)
        if thumbnail:
            subprocess.run(cmd + [
                "-i", str(output), "-frames:v", "1", "-update", "1", str(thumbnail),
            ], cwd=work, check=True)
    print(output)
    if thumbnail:
        print(thumbnail)

if __name__ == "__main__":
    main()
