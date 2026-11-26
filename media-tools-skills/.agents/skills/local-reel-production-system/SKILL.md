---
name: local-reel-production-system
description: Turn footage and editing references into repeatable local Reels using a style profile, word-timed transcription, a structured edit plan, reusable graphics, and export review.
---

# Local reel production system

Use this skill to learn and apply a chosen Reel or Short style while keeping the edit local and reproducible. The style mode is a project choice: use the established clean-caption and selective-popup style by default; choose the object-led split mode when the user supplies a reference or asks for varied animated visual inserts.

The toolkit already supports multiple style profiles. The [original reel workflow reference](https://www.youtube.com/shorts/fTauJDVaUBw) demonstrates edit orchestration. The [object-led split Reel mode](references/object-led-reel-mode.md) adds a distinct evidence-insert and real-object-popup option. Use each mode only when it fits the brief.

## Tool map

| Agent task | Local tool |
| --- | --- |
| Inspect sources and export metadata | `tools/agent-edit/ffmpeg-skill.cmd`, `tools/agent-edit/mediainfo.cmd`, and bundled `tools/ffmpeg/bin/ffprobe.exe` |
| Optional authorized YouTube source acquisition | `tools/youtube-downloader/download-video.ps1`; prefer supplied local sources or browser-only visual references when sufficient. |
| Word-timed captions/transcript | `tools/opusclip-local/caption-batch.cmd` with the local Whisper models; choose `auto` when English/Tagalog code-switching is possible |
| Match selected spoken object aliases to exact times | `tools/agent-edit/mention-plan.cmd`; this proposes timing and placement, it does not extract images or render graphics |
| Animate supplied/source-derived cutouts, cards, and reaction graphics | `tools/hyperframes/hyperframes-local.cmd` with bundled HyperFrames and project-local GSAP; render transparent WebM and composite with bundled FFmpeg |
| Composite a prebuilt still PNG with alpha | `tools/python-video/moviepy-overlays.cmd`; this handles positioned timed still layers, not animated scale/rotation paths |
| Transition between designed scenes or cutaways | `tools/agent-edit/motion-transition.cmd`; use `zoom-reveal`, `iris-open`, `side-push`, or `clean-dissolve` from `tools/agent-edit/MOTION_TRANSITIONS.md` |
| Optional shader transition | `tools/gl-transitions/gl-transition.cmd`; check the local graphics adapter with `doctor` before rendering |
| Make a vertical base clip | `tools/media-lab/media-lab.cmd reframe` or the local FFmpeg timeline workflow |

Use wrapper help before a command when its arguments are unfamiliar. Run from the toolkit root or provide full paths. Do not use `npx` to fetch packages; use the bundled local HyperFrames wrapper.

## Workflow

1. Inspect source duration, resolution, frame rate, audio, existing captions, and any supplied edit plan. Keep source files unchanged.
2. Choose a style profile before building overlays. Keep observed reference traits separate from design choices. Do not apply a reference’s layout to unrelated projects unless it fits or the user requests it.
3. Transcribe locally. Select story beats and spoken mentions from the transcript and footage; use final-cut timestamps after any trims or transitions.
4. Build captions and visual inserts as separate layers. Use `mention-overlays-local` for mention timing and `contextual-visual-design-local` for original visuals. Select the animation/compositing tool from the map above and the style reference.
5. Render a new copy locally. Keep editable project files and a manifest of source timing, overlay timing, asset paths, and output paths with the project.
6. Review the opening, representative caption and overlay frames, transitions, ending, audio, and export metadata. Correct overlaps and timing before delivery.

For full batch selection, file layout, and export review, use `shorts-production-local` and its production workflow reference. This style skill does not replace `opusclip-local` for a single clip or the overlay skill for its render contract.
