"""Run the pinned editing tools through the bundled Python runtime."""
import re
import runpy
import sys
from pathlib import Path

skills = Path(__file__).resolve().parents[2] / ".agents" / "skills"
mode = sys.argv.pop(1)
if mode == "ffmpeg":
    if len(sys.argv) < 2 or not re.fullmatch(r"[a-z][a-z0-9_]*", sys.argv[1]):
        raise SystemExit("Usage: ffmpeg-skill.cmd TOOL [options]; use doctor or contract to start.")
    tool = sys.argv.pop(1)
    scripts = skills / "ffmpeg-skill" / "scripts"
    script = scripts / ("_contract.py" if tool in {"doctor", "contract"} else f"{tool}.py")
    if not script.is_file():
        raise SystemExit(f"Unknown FFmpeg tool: {tool}")
    if tool in {"doctor", "contract"}:
        sys.argv.insert(1, tool)
    sys.path.insert(0, str(scripts))
    runpy.run_path(str(script), run_name="__main__")
elif mode == "timeline":
    sys.path.insert(0, str(skills / "video-editing-skill" / "src"))
    runpy.run_module("video_editing_skill.cli", run_name="__main__")
else:
    raise SystemExit("Unknown launch mode.")
