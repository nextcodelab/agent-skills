---
name: professional-local-editing
description: Plan and execute professional local video, audio, image, caption, and motion graphics edits using the portable video-editors tools and reusable assets. Use for local media edits, audio extraction/finishing, captions, reframing, effects, or reusable presets.
---

# Professional Local Editing

Keep production local. Agents make editorial decisions and operate scripts/desktop tools; never send user media, transcripts, assets, or prompts to hosted editing/transcription services. Do not read vendor credentials or use API keys. Preserve sources and write new deliverables where the user directs.

## Route by task

- For song lyrics and sing-along videos, use `lyrics-video-local` for editable timing, reusable styles, and local MP4 export.

- For object popups and explanatory cutaways tied to speech, use `mention-overlays-local`.
- When the edit needs a new contextual image, diagram, or visual metaphor, use `contextual-visual-design-local`.
- For a repeatable workflow based on reference reels, use `local-reel-production-system`.

- For editorial decisions about pacing, retakes and B-roll, read the relevant `editing-videos` guidance and use the local tools specified here.
- For scene analysis, repeated trims/joins, and technical delivery checks, use the bundled wrappers in `tools/agent-edit/`.
- For podcast Shorts, follow `podcast-hooks-local` and inspect the opening frame for the hook before delivering.

- Inspect first with `tools/media-lab/media-lab.cmd probe <source>`.
- Extract audio with `tools/media-lab/media-lab.cmd extract-audio <video> <audio.wav>`.
- Finish speech with `audio-finish --denoise --voice --normalize`; process gently and review/listen.
- Add local music/SFX under video with `mix-bed`; start quietly and check voice intelligibility.
- Reframe video or apply restrained clean/warm looks with `reframe`. It crops/contains without blur, but does not auto-track faces.
- Resize or treat a still with the `image` command.
- Generate original piano-like or transition cues using `tools/media-lab/synth-sfx.cmd`; label them synthetic, not acoustic recordings.
- For English/Tagalog/Taglish, use `tools/opusclip-local/caption-batch.cmd` with `--language en`, `tl`, or `auto`. Follow `tools/captioning/README.md`; check transcripts, names, code-switching, timing, and captions before export.
- Use `tools/opusclip-local/zoom.cmd` for no-blur zoom motion. Use `hyperframes-local` for authored motion and `hyperframes-overlays-local` for contextual overlays. Prefer existing local sticker/SVG/text packs for simple treatments.

## Workflow

1. Read the brief/source and inspect streams, dimensions, frame rate, duration, and sound.
2. Search `assets/` for matching caption styles, text animations, stickers, overlays, memes, transitions, and sound cues. Use effects with context and avoid obscuring faces or captions.
3. Choose the smallest fitting local tool. Use Python/FFmpeg for repeatable transforms, HyperFrames for designed motion, and desktop computer-use controls when actual GUI operation or visual review is needed. Browser rendering can vary by machine.
4. Write outputs to the user's destination, never over the source. Keep intermediates in a per-project work folder.
5. Review the result visually and listen: crop, timing, caption readability/sync, start/end, audio balance/clipping, and export size. Do not claim checks you did not perform.
6. If genuinely reusable, save editable source under `assets/` or `tools/` with unique ID, context tags, usage, provenance/license notes. Update catalog/docs and regenerate `FILE_TREE.md`.

## Reference

See `tools/media-lab/README.md`, `tools/opusclip-local/README.md`, `tools/captioning/README.md`, `tools/hyperframes/README.md`, and `PORTABILITY.md`. Do not claim full proprietary CapCut parity; name only the local operation performed.
