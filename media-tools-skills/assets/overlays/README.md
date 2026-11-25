# Reusable local overlay cards

Each clip has a transparent PNG render for fast FFmpeg compositing and a matching editable SVG in `svg/`. The generic `templates/hook-card-template.svg` is the design template. Keep overlays as assets; HyperFrames is unnecessary for this reusable card style.

## Current campaign set

- Nine-by-sixteen source clips are kept in `../..` and were not modified.
- Finished copies are in `../../files/`. Original audio is stream-copied; no extra music or sound effects are added.
- Each card appears from 0.18 to 4.55 seconds with a short upward slide and alpha fade, placed above the bottom safe margin.
- Copy is derived only from the supplied clip title because no transcript/subtitle track was present. Review hook wording against the footage before posting.
- The campaign tone is curious and sharp, never mocking or cynical. No unrelated b-roll, third-party marks, or unsupported assertions are added.

## Reuse

Use a matching SVG/PNG from `svg/` and `png/`, or replace `{{SERIES_LABEL}}`, `{{HOOK_TEXT}}`, and `{{ICON_SVG}}` in the template to make a new one. Keep the card under 960x240, with the main hook short enough for one line. The CSV manifest records the source, output, topic, timing, and asset paths.

The PNGs were rasterized locally with Pillow; FFmpeg applies the entrance/fade animation and composites them. No cloud rendering, HyperFrames, external fonts, music, or service API is used.
# Mention popup templates

See [mention-popup assets](templates/mention-popups/README.md) for reusable original graphics that agents can time with `mention-plan.cmd`.
