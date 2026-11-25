"""Layer a JSON list of timed local images over a video using MoviePy."""
import argparse
from contextlib import ExitStack
import json
import math
from pathlib import Path
from tempfile import TemporaryDirectory


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=lambda value: Path(value).resolve())
    parser.add_argument("plan", type=lambda value: Path(value).resolve())
    parser.add_argument("output", type=lambda value: Path(value).resolve())
    args = parser.parse_args()
    if not args.source.is_file() or not args.plan.is_file():
        parser.error("Provide an existing local video and overlay plan.")
    if args.output.exists() or args.output.suffix.lower() != ".mp4":
        parser.error("Choose a new .mp4 output path.")

    from moviepy import CompositeVideoClip, ImageClip, VideoFileClip

    try:
        plan = json.loads(args.plan.read_text(encoding="utf-8-sig"))
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with ExitStack() as stack:
            base = stack.enter_context(VideoFileClip(str(args.source)))
            layers = [base]
            for layer in plan["layers"]:
                asset = (args.plan.parent / layer["file"]).resolve()
                if not asset.is_file() or asset.suffix.lower() not in {".png", ".jpg", ".jpeg", ".webp"}:
                    raise ValueError(f"Layer must be an existing PNG, JPEG or WebP: {asset}")
                start, end = float(layer["start"]), float(layer["end"])
                if not (math.isfinite(start) and math.isfinite(end) and 0 <= start < end <= base.duration):
                    raise ValueError(f"Invalid overlay time for {asset.name}.")
                image = stack.enter_context(ImageClip(str(asset), transparent=True))
                if "width" in layer:
                    width = int(layer["width"])
                    if not 1 <= width <= base.w:
                        raise ValueError(f"Overlay width must be from 1 to {base.w}.")
                    image = image.resized(width=width)
                position = (int(layer.get("x", 0)), int(layer.get("y", 0)))
                layers.append(image.with_position(position).with_start(start).with_end(end))

            composite = stack.enter_context(CompositeVideoClip(layers, size=base.size, bg_color=(0, 0, 0)))
            with TemporaryDirectory(prefix=".moviepy-", dir=args.output.parent) as work:
                staged = Path(work) / "render.mp4"
                composite.write_videofile(
                    str(staged), fps=base.fps, codec="libx264", audio_codec="aac",
                    temp_audiofile=str(Path(work) / "audio.m4a"), preset="fast",
                    ffmpeg_params=["-crf", "18", "-movflags", "+faststart"], logger=None,
                )
                staged.rename(args.output)
    except (OSError, ValueError, KeyError, TypeError, RuntimeError) as exc:
        parser.exit(1, f"Error: {exc}\n")
    print(args.output)


if __name__ == "__main__":
    main()
