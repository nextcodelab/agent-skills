# Local Media Lab

Agent-run, offline-first helpers for common CapCut-style production tasks. Python scripts orchestrate bundled FFmpeg/ffprobe and local Whisper; there are no vendor API keys, hosted render calls, or upload steps. Agents choose the edit, inspect source/context, run a local script, and review the exported copy.

## Ready commands

Run these from PowerShell in the toolkit root, or pass full paths:

```powershell
.\tools\media-lab\media-lab.cmd probe "input.mp4"
.\tools\media-lab\media-lab.cmd extract-audio "input.mp4" "work\audio.wav"
.\tools\media-lab\media-lab.cmd audio-finish "work\audio.wav" "work\voice-clean.wav" --denoise --voice --normalize
.\tools\media-lab\media-lab.cmd mix-bed "input.mp4" "assets\music\bed.wav" "output\music-mix.mp4" --duration 30 --bed-volume 0.10
.\tools\media-lab\media-lab.cmd reframe "input.mp4" "output\vertical.mp4" --width 1080 --height 1920 --fit cover --look clean
.\tools\media-lab\media-lab.cmd image "poster.png" "output\poster-vertical.png" --width 1080 --height 1920 --fit contain
.\tools\media-lab\synth-sfx.cmd soft-piano "assets\sound-effects\synthetic\soft-piano.wav" --duration 1.5
```

For a WAV master, `audio-finish` writes 24-bit PCM at 48 kHz by default; adjust with `--sample-rate`. MP3 and AAC/M4A use the selected bitrate.

Caption/transcription already runs with `tools/opusclip-local/caption-batch.cmd`: English `--language en`, Tagalog `--language tl`, Taglish/code-switching `--language auto` with the bundled multilingual Whisper model. It writes transcript JSON/TXT, ASS/SRT captions, and a new captioned video; agents review names, code-switching, timing, and point highlights. Use optional `--prompt` only for names or topic vocabulary; the default is unbiased for general content. Use the existing zoom tool for animated punch-ins and the local HyperFrames skill for designed scenes. See `.agents/skills/professional-local-editing/SKILL.md`.

The feature roadmap mapping familiar CapCut tasks to this local implementation is in `CAPCUT_FEATURE_MAP.md`.

## Current boundaries

- `reframe` cover-crops or contains/pads without blur; it does not track a speaker or moving face.
- Voice cleanup is a restrained FFmpeg filter chain, not source separation. `mix-bed` adds a quiet local bed under original sound; listen for clipping and balance.
- `synth_sfx.py` creates original procedural piano-inspired and transition cues, not acoustic instrument recordings.
- Export to the user's requested destination. Preserve sources; do not place campaign exports in this reusable toolkit.
- System fonts may differ between PCs. Use local SVG/PNG and bundled tools for consistent portable results.

## Extend it

Search `tools/`, `assets/`, and `.agents/skills/` before adding a preset/script. Save reusable results with editable source, unique ID, context tags, usage and provenance notes; update the relevant catalog and regenerate `FILE_TREE.md`:

```powershell
.\tools\python\3.12.10-embed-amd64\python.exe .\tools\inventory\build_tree.py
```
