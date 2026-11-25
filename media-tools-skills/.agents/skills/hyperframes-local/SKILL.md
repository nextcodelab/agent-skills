---
name: hyperframes-local
description: Create and edit designed videos with HyperFrames using a coding agent and local rendering tools. Keep footage and renders local; avoid HeyGen services and API keys.
---

# HyperFrames Local

Use the coding agent to author and revise HTML, CSS, SVG, and seekable animation for designed videos, then render locally with HyperFrames. This skill complements `opusclip-local`: use that skill to extract short clips from existing footage; use this one for titles, explainers, motion graphics, product videos, overlays, and designed compositions.

## Local-only rules

- Do not call HeyGen cloud rendering, HeyGen media generation, hosted MCP, OpusClip services, or any other hosted video or media API.
- Do not read, display, copy, or use API keys or tokens. No vendor key is needed for local render.
- Do not run `hyperframes cloud`, `lambda`, `cloudrun`, `publish`, `share`, or provider-backed media workflows. In particular, do not run `media-use` for externally sourced/generated content.
- Prefer supplied media and assets already on this computer. Use local tools and local models only. If a requested capability would need a hosted service, explain that constraint and offer a local option.
- Keep original footage unchanged. Put project files under `projects/` and renders under that project's `exports/`.

## Workflow

1. Ask the user for the intended video, format, duration, style, source assets, and destination; infer ordinary defaults from the request.
2. Inspect the local source files and available tools without exposing secrets. Check `node --version`, `ffmpeg -version`, and `npx hyperframes --version` when using the CLI.
3. Create or edit the project using the coding agent. When scaffolding, use `npx hyperframes init <project-folder> --skip-skills` to avoid installing unrelated service workflows.
4. Preview the composition locally with `npx hyperframes preview`. Iterate on layout, timing, and animation with the user’s brief and local assets.
5. Run local checks when available, then render with `npx hyperframes render --output <project-folder>/exports/<name>.mp4`. Never substitute cloud rendering.
6. Inspect the resulting file’s duration, dimensions, playback, and representative frames. Report the saved path and any limits.

If HyperFrames or its local dependencies are unavailable, use local HTML/SVG plus FFmpeg where practical, or explain what local dependency needs installation. Installing a package may require network access; do not upload the user's footage or project to install or use it.
