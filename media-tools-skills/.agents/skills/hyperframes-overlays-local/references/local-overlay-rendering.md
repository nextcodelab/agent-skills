# Local HyperFrames overlay rendering

## Composition

Create a portrait HyperFrames project at the target output resolution. Set `html`, `body`, and the composition root to transparent. Use a paused GSAP timeline registered with the root composition ID so the renderer can seek deterministically. Use local assets and fonts; avoid `Date.now()`, `Math.random()`, remote fetches, and CSS animations that depend on wall-clock time.

For a brief popup, a 3–4 second transparent composition is usually enough. Put the popup entry and optional secondary chip on a visible timeline, then fade/scale them out before the composition ends. Keep the effect’s start offset in the clip plan or effects manifest.

For randomized-looking motion, choose entry, exit, speed, rotation, and safe landing-position options once per clip from a stable seed, then write those choices into the effects manifest. Never use per-frame `Math.random()` or wall-clock timing in a seeked timeline; the same clip must render the same way on every pass.

Render on the machine with the installed CLI, for example:

```powershell
npx hyperframes render . --format webm --fps 30 --output overlays/sticker_01.webm
```

Do not sign in or use cloud rendering for this workflow. If the project scaffold references a CDN, replace it with a local dependency before rendering.

## FFmpeg compositing

VP9 alpha must be decoded with FFmpeg’s VP9 decoder. Place `-c:v libvpx-vp9` before the transparent WebM input, then overlay it with its intended time offset:

```powershell
ffmpeg -i base.mp4 -c:v libvpx-vp9 -itsoffset 8 -i sticker.webm `
  -filter_complex "[0:v][1:v]overlay=eof_action=pass:shortest=0:format=auto[v]" `
  -map "[v]" -map "0:a?" -c:v libx264 -preset veryfast -crf 20 `
  -pix_fmt yuv420p -c:a copy enhanced.mp4
```

Use the user’s chosen output resolution and codec when they provide one. Otherwise match the base clip’s duration, frame rate, dimensions, and audio. Write enhanced files into a separate folder rather than overwriting their bases.

## Alpha check

Probe the WebM for `ALPHA_MODE=1`. Before batching, composite one sample over a real clip and inspect it; a black rectangle means alpha was not decoded or the composition background is opaque. Do not continue the batch until the sample shows the original footage behind the overlay.
