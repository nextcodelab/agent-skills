"""Check a local Shorts folder for delivery format, runtime and clip count."""

import argparse
import csv
import json
import subprocess
import sys
from fractions import Fraction
from pathlib import Path


_BUNDLED_PROBE = Path(__file__).resolve().parents[1] / "ffmpeg" / "bin" / "ffprobe.exe"
_FFPROBE = str(_BUNDLED_PROBE) if _BUNDLED_PROBE.is_file() else "ffprobe"


def probe(path):
    return json.loads(subprocess.check_output(
        [_FFPROBE, "-v", "error", "-show_streams", "-show_format", "-of", "json", str(path)],
        encoding="utf-8",
    ))


def audit_file(path, minimum, maximum, broll=None):
    info = probe(path)
    video = next((s for s in info["streams"] if s["codec_type"] == "video"), {})
    audio = next((s for s in info["streams"] if s["codec_type"] == "audio"), {})
    run = float(info["format"]["duration"])
    fps = float(Fraction(video["r_frame_rate"])) if video.get("r_frame_rate") not in (None, "0/0") else None
    resolution = [video.get("width"), video.get("height")]
    issues = []
    if resolution != [1080, 1920]:
        issues.append("Expected 1080×1920")
    if not minimum <= run < maximum:
        issues.append(f"Duration outside [{minimum}, {maximum}) seconds")
    if video.get("codec_name") != "h264" or audio.get("codec_name") != "aac":
        issues.append("Expected H.264 video and AAC audio")
    if broll is not None and not 0 <= broll <= run / 4:
        issues.append("Replacement footage exceeds 25% of runtime")
    return {
        "file": path.name, "duration": run, "resolution": resolution, "fps": fps,
        "video_codec": video.get("codec_name"), "audio_codec": audio.get("codec_name"),
        "planned_cutaway_seconds": broll, "issues": issues,
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("folder", type=Path, help="Folder containing the exported MP4 files")
    parser.add_argument("--count", type=int, help="Expected number of MP4s")
    parser.add_argument("--min", type=float, default=10, help="Inclusive minimum seconds")
    parser.add_argument("--under", type=float, default=30, help="Exclusive maximum seconds")
    parser.add_argument("--report", type=Path, help="Write JSON report to this file")
    args = parser.parse_args(argv)
    files = sorted(args.folder.glob("*.mp4"))
    manifest = args.folder / "clips_manifest.csv"
    planned_cutaways = {}
    if manifest.is_file():
        with manifest.open(encoding="utf-8-sig", newline="") as f:
            for row in csv.DictReader(f):
                if "source_broll_seconds" in row and "added_cutaway_seconds" in row:
                    planned_cutaways[row["filename"]] = (
                        float(row["source_broll_seconds"]) + float(row["added_cutaway_seconds"])
                    )
    reports = [
        audit_file(f, args.min, args.under, planned_cutaways.get(f.name))
        for f in files
    ]
    issues = []
    if not files:
        issues.append("No MP4 files found")
    if args.count is not None and len(files) != args.count:
        issues.append(f"Expected {args.count} MP4 files, found {len(files)}")
    if planned_cutaways and {f.name for f in files} != planned_cutaways.keys():
        issues.append("Manifest filenames do not match MP4 files")
    passed = not issues and all(not report["issues"] for report in reports)
    report = {
        "count": len(files), "passed": passed, "batch_issues": issues, "clips": reports,
        "note": "Visual framing, actual source coverage and subtitle accuracy require review of the video.",
    }
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    if passed:
        durations = [r["duration"] for r in reports]
        print(f"{len(files)} clips passed, {min(durations):.2f}–{max(durations):.2f} seconds")
    else:
        for issue in issues:
            print(issue, file=sys.stderr)
        for clip in reports:
            for issue in clip["issues"]:
                print(f"{clip['file']}: {issue}", file=sys.stderr)
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
