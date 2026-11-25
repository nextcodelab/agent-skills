# Agent-run local clipper and caption tools

This is the local implementation called by the `opusclip-local` skill. It does not connect to OpusClip, use vendor keys, or upload media. The agent plans and reviews edits; bundled Whisper transcribes locally; bundled FFmpeg produces new files.

- `scripts/caption_batch.py` — multilingual speech transcription, word-timed captions, transcript sidecars, and optional active-word karaoke.
- `presets/emphasis.json` — local topic words eligible for keyword highlighting.
- `scripts/zoom.py` / `zoom.cmd` — portrait zoom/punch presets without a blurred background.
- `caption-batch.cmd` — invokes the bundled Python runtime for captioning.

Caption example:

```powershell
.\caption-batch.cmd --input-dir "C:\path\to\clips" --output-dir "C:\path\to\captioned" --transcript-dir "C:\path\to\transcripts" --language auto --style "..\..\assets\captions\styles\podcast-clean-highlight.json"
```

Use `--language en` for English, `tl` for Tagalog, and `auto` with the multilingual model for Taglish/code-switching. Review names and code-switched phrases against source audio. Use `--karaoke` for active-word coloring; otherwise topic terms from the local emphasis preset are highlighted.

Transcription starts with no topic prompt to avoid bias across industries. For names or specialist terms, pass an optional `--prompt "Name One, Name Two, topic terms"`.

Zoom example:

```powershell
.\zoom.cmd --input "input.mp4" --output "zoomed.mp4" --preset slow-in
```

Available zoom presets: `slow-in`, `slow-out`, `punch-in`, `punch-out`, and `pulse`. Existing output files are protected unless `--overwrite` is supplied.
