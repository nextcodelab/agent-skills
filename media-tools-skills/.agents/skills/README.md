# Agent skill index

Skills stay directly under `.agents/skills/` for Codex discovery. Organize by skill name and this index rather than nesting them.

## Reels and Shorts

- `shorts-production-local`: batches of captioned vertical Shorts using local tools.
- `opusclip-local`: agent-driven local clipping, captions, reframing, and export. Uses our local scripts; not the OpusClip service.

## Motion graphics and overlays

- `hyperframes-local`: full designed motion graphics through local HyperFrames CLI.
- `hyperframes-overlays-local`: contextual overlay workflow; reuse SVG/PNG assets and FFmpeg for simple cards before authoring new HyperFrames scenes.
- `horizontal-blur-reveal-local`: apply the short sideways blur or the blur with a quick zoom settle.

## Full local post-production

- `editing-videos`: editorial decisions, pacing, retakes, B-roll, and finishing.
- `ffmpeg-skill` and `video-editing-skill`: local FFmpeg operations, delivery checks, and structured edits. Use the portable wrappers documented in `tools/agent-edit/README.md`.
- `podcast-hooks-local`: opening frame titles, timed dialogue captions, and matching thumbnails.
- `lyrics-video-local`: sync supplied lyrics to a song, review word timing, and render videoke or lyric videos in reusable styles.
- `podcast-gold-header-local`: reference-based black headline band, close speaker framing, and bold gold podcast captions.
- `mention-overlays-local`: time object popups and cutaways from the local transcript, and save select reusable graphics.
- `contextual-visual-design-local`: invent illustrations, diagrams, and mockups from the meaning of the clip, then use them as popups or cutaways.
- `local-reel-production-system`: learn a style from reference reels and coordinate the local edit from footage through export; includes the optional object-led split Reel mode and its local agent tool map.

- `professional-local-editing`: routes mixed requests across local Python/FFmpeg, Whisper captions, zoom, reusable assets, HyperFrames, and optional desktop computer controls.

All workflows keep media and credentials local.

## brief2mp4 local motion graphics

- `brief2mp4-local` turns written briefs into structured motion-graphic, explainer, lyric, and short-video projects, with a self-check/report workflow.
- It uses the existing local HyperFrames, FFmpeg, ffprobe, Node, and Python runtimes through `tools/brief2mp4-local/brief2mp4.ps1`.
- Its shared GSAP and Three.js browser libraries are cached once under `tools/brief2mp4-local/vendor-cache/`; see that folder's `NOTICE.md` for license details. They are copied into a project only when needed for offline portability.
- Blender, the optional 3D CAD/physics pack, Git Bash, and AI image-to-3D models are not bundled. HyperFrames still relies on the local headless browser, which has crashed on this machine before.

