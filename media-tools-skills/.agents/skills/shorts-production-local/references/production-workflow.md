# Production workflow

## Tool roles

- **ffprobe**: inspect source and rendered stream metadata without decoding the entire video.
- **FFmpeg**: trim, crop, scale, zoom, burn subtitles, preserve audio, encode H.264/AAC, and create contact sheets.
- **Local transcript or ASR**: identify context and timestamp captions. Do not invent speech or claim word-level sync from sentence-level timestamps.
- **HyperFrames**: author designed HTML/CSS/GSAP graphics or transparent animations. Render locally only; see `hyperframes-overlays-local` for stickers and popups.

## Suggested file layout

```text
video-editors/
  raw/                         original media; never overwrite
  projects/<project>/          scripts, transcript, subtitle files, review frames
  outputs/<title>/
    files/                     base vertical exports
    enhanced/                  enhanced copies with effects
    shorts_manifest.csv
    effects_manifest.csv       when a separate effect pass is made
```

Keep existing file names stable when rerendering. If an output exists, render to a temporary name, review it, then replace only when the user requested an update or the output is clearly a new version.

## Crop and caption decisions

- Crop to the requested aspect ratio and keep the main speaker or action inside the frame throughout the clip. Revisit the crop if the active subject moves.
- If the source already contains subtitles, inspect their position. Either crop the subtitle strip out without losing important action or move the new captions above it; do not create a second unreadable line.
- Use a locally available font. Keep words short enough for mobile, use safe margins, strong contrast, and a restrained outline or backing.
- If the user asks for animated captions, prefer a small pop/fade or progressive word highlight based on timing actually available. Avoid fake precise timing.

## Review

For each render, compare expected and actual duration, check for 9:16 dimensions and audio, inspect a frame near the start and around the most important moment, and scan the full batch with a contact sheet. Check for clipped text, faces hidden by graphics, bad crops, black gaps, subtitle collision, or abrupt audio cuts.
