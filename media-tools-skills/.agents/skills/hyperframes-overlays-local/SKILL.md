---
name: hyperframes-overlays-local
description: Add short, context-matched animated stickers, emoji, popups, and callouts over existing Shorts using local HyperFrames and FFmpeg. Use when the user asks for an effects pass on finished clips; for a complete designed video, use hyperframes-local.
---

# HyperFrames Overlays Local

Create a separate animated overlay for each selected clip, then composite it over the existing video locally. Keep the edit reversible: retain the base clips and render enhanced copies into `outputs/<title>/enhanced/`.

## Local-only rules

- Use HyperFrames’ local CLI, local GSAP, local fonts/assets, and FFmpeg. Do not use `cloud`, `publish`, `share`, hosted media generation, OpusClip, HeyGen, hosted MCP, or a service API.
- Do not read or display vendor keys. Local overlay rendering and compositing need no vendor API key.
- Avoid CDN scripts, remote fonts, and externally sourced stickers. Use project-local assets or installed system fonts.
- Keep the footage and original audio unchanged; write new output files.

## Effect design

1. Read the clip plan and transcript around each effect. For a conventional effects pass, choose one or two brief beats. For the optional object-led split Reel mode, use several selected story beats across the clip, not a popup on every noun; see `../local-reel-production-system/references/object-led-reel-mode.md`.
2. Keep humor friendly. Do not mock the person, use humiliating memes, or turn serious or emotional moments into a joke. For a personal or emotional moment, use a simple supportive motif or skip the effect.
3. Place graphics near an open edge of the frame, away from faces, gestures, existing captions, and platform controls. Keep the base footage readable.
4. Vary popup choreography across selected beats: mix rotate-and-scale entrances, fast slides, soft fades, short arcs, and slower drifts; vary direction, speed, landing lane, hold, and exit (including fade-plus-rotation). Inspect each shot and use an open safe position, avoiding faces, demonstrated hands, dialogue captions, and platform controls. Do not repeat an identical motion/position pair on adjacent beats. If using random variation, choose from safe authored options with a stable clip seed, record the choices, and keep the seeked GSAP timeline deterministic.
5. Render transparent WebM locally from a HyperFrames composition with a transparent root and deterministic, seekable GSAP animation. Use a bundled local GSAP file rather than a CDN. Run the installed local HyperFrames lint command through `tools/hyperframes/hyperframes-local.cmd`; fix errors. Local-font warnings are acceptable only when the render is local and the font exists on this machine.
6. Composite the transparent WebM over its matching clip at the planned timestamp. Preserve the original clip duration and audio. Write the exact effect time and output path in `effects_manifest.csv`.
7. Review a contact sheet sampled while each sticker is visible. Check alpha, text legibility, safe positioning, context match, and that no sticker covers a face or the underlying caption.

For the transparent WebM and FFmpeg details, read [local overlay rendering](references/local-overlay-rendering.md).


