# Local lyrics and videoke videos

The toolkit renders lyrics over audio using the bundled FFmpeg, Python, and optional local Whisper. Run from the toolkit root:

```powershell
.\tools\lyrics-video\lyrics-video.cmd styles
.\tools\lyrics-video\lyrics-video.cmd align "D:\song\vocal-mix.wav" "D:\song\lyrics.txt" "D:\song\draft.lrc" --language tl
.\tools\lyrics-video\lyrics-video.cmd render "D:\song\instrumental.wav" "D:\song\reviewed.lrc" "D:\song\videoke.mp4" --style classic-videoke
```

Use `en` for English, `tl` for Tagalog, and `auto` for a mixed track. Prefer a clean vocal stem when you have one. The align step runs Whisper locally and matches the words to your supplied text in song order. It writes a review JSON and includes complete matched lines in the draft. Recognition can be wrong on music, particularly with repeated phrases or layered vocals. Review the draft and fill in missing lines. You can also supply existing word-timed JSON with `--transcript`. Use an instrumental for the final sing-along only if it is synchronized with the vocal mix you timed.

## Timing

If the singing is buried under music, try the bundled [CPU vocal separator](../vocal-separation/README.md) before aligning. Use the vocal stem for recognition and keep the original mix or the time-aligned backing track for delivery.

Standard LRC sets the start of a line. Enhanced LRC adds a start for each word and an optional ending timestamp.

```lrc
[00:02.000]This line appears all at once
[00:05.000]<00:05.000>Sing <00:05.430>along <00:05.820>with <00:06.150>me<00:07.080>
[00:07.100]
```

A timestamp with no text clears the screen for an instrumental break. For line-only lyrics, the default line hold is capped at eight seconds. Use `--max-hold` for a different default or specify explicit timing with Enhanced LRC.

## Styles and export

Choose `classic-videoke`, `neon-stage`, `cinema-serif`, `bubble-pop`, `monospace-mint`, `stadium-chant`, or `soft-pastel`. Presets live under `assets/text/styles/lyrics-video/presets.json`. Add a style by giving it a new ID and choosing its font, colors, placement, and highlight behavior. Font availability can differ between PCs.

The renderer defaults to 1920×1080 at 30 fps. For a vertical lyric video, pass `--width 1080 --height 1920`. For a background still, pass `--background "D:\song\cover.png"`. The output includes the audio, burned-in lyrics, and an editable ASS sidecar next to the MP4. Keep the LRC to make future timing changes.
