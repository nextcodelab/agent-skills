"""Expose the private video packages to a local Python script."""
import os
from pathlib import Path
import runpy
import sys

if len(sys.argv) < 2:
    raise SystemExit("Usage: python-video.cmd SCRIPT.py [arguments]")
vendor = Path(__file__).resolve().with_name("vendor")
if not vendor.is_dir():
    raise SystemExit(f"Portable video packages missing from {vendor}")
script = Path(sys.argv.pop(1)).resolve(strict=True)
sys.path[:0] = [str(script.parent), str(vendor)]
os.environ.setdefault("PYGAME_HIDE_SUPPORT_PROMPT", "1")
runpy.run_path(str(script), run_name="__main__")
