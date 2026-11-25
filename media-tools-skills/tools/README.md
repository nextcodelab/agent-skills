# Portable local video tools

This workspace bundles agent-run local media tools for Windows x64. Copy `tools/`, `.agents/skills/`, and `assets/` together for a portable backup. Never add vendor API keys. Source footage, transcripts, assets, and renders stay local.

## Packages

- `ffmpeg/` — portable FFmpeg and ffprobe for extraction, filters, encoding, and inspection.
- `agent-edit/` — portable launchers for editorial scene analysis, structured timeline edits, export checks, and podcast hook/thumbnail rendering.
- `mediainfo/` — portable MediaInfo CLI for video, audio and subtitle metadata.
- `python-video/` — portable MoviePy and native graphics dependencies, with a timed image overlay command.
- `gl-transitions/` — locally rendered shader transitions using native WebGPU and the bundled FFmpeg.
- `lyrics-video/` — local lyric timing and videoke rendering with editable styles and seven presets.
- `vocal-separation/` — portable CPU vocal/accompaniment separation, with a command and an importable Python wrapper.
- `upstream-editing/` — additional editing skill references, pinned to upstream revisions listed in `agent-edit/README.md`.
- `captioning/` — local whisper.cpp CPU build plus English-only and multilingual Whisper models.
- `python/` — embeddable Python runtime for reusable scripts.
- `opusclip-local/` — our local clip-selection/caption workflow, not OpusClip's hosted product. Agents plan/review; local Python, Whisper, and FFmpeg generate files.
- `media-lab/` — Python workbench for metadata inspection, video-to-audio extraction, speech audio finishing, local music/SFX mixing, image resizing/treatment, clean aspect-ratio reframing, and original procedural cues.
- `hyperframes/` — local HyperFrames CLI and portable Node runtime. Use `hyperframes-local.cmd`; its wrapper blocks cloud/publish/share workflows. Agents create and run local scenes; no API key is read.

See `.agents/skills/professional-local-editing/SKILL.md` for task routing and `tools/media-lab/README.md` for commands/limits. Captions use the existing local Whisper batch workflow; English, Tagalog, and Taglish modes are documented there and in `tools/captioning/README.md`.

## Caption workflow

The caption runner writes new captioned video copies and transcript sidecars. For English use `--language en` (bundled `small.en` model). For Tagalog use `--language tl`; for Taglish/code-switched speech use `--language auto` with the multilingual `small` model. ASR transcripts need a human pass for names and code-switching. Pick a reusable JSON style with `--style`; use `--karaoke` for active-word highlighting.

Example for the Clipping campaign:

```powershell
.\tools\opusclip-local\caption-batch.cmd `
  --input-dir "C:\Users\Robel\Downloads\Clipping\output\files" `
  --output-dir "C:\Users\Robel\Downloads\Clipping\output\files\captioned" `
  --transcript-dir ".\industries\hip-hop-clipping\transcripts\ep5" `
  --language en `
  --style ".\assets\captions\styles\podcast-clean-highlight.json"
```

Review transcripts and rendered captions before publishing. Topic highlights only apply to words actually present in the transcript. The caption script writes a manifest into the output directory.

## Zoom workflow

Use the bundled zoom presets to create a new MP4 without a blurred background:

```powershell
.\tools\opusclip-local\zoom.cmd --input "input.mp4" --output "zoomed.mp4" --preset punch-in
```

Available presets are `slow-in`, `slow-out`, `punch-in`, `punch-out`, and `pulse`. See `tools/opusclip-local/README.md` for parameters.

## HyperFrames

```powershell
.\tools\hyperframes\hyperframes-local.cmd --version
.\tools\hyperframes\hyperframes-local.cmd init .\projects\sample --skip-skills
.\tools\hyperframes\hyperframes-local.cmd render --help
```

Use local assets first for simple cards, stickers, and captions. Use HyperFrames for layouts or motion that benefit from authored HTML/SVG/GSAP scenes. No CDN scripts, remote fonts, or externally sourced stickers; use project-local assets and installed fonts.
