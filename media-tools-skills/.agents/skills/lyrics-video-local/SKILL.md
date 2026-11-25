---
name: lyrics-video-local
description: Create offline lyric and videoke videos with timed lines or word highlights, reusable typography, and a local background. Use when a user supplies audio and lyrics for karaoke or a lyric video.
---

# Local lyric and videoke video

1. Use the user's audio and supplied lyrics. Confirm whether the final audio should include singing or be instrumental. A separate instrumental may be used for export if it shares the same timeline as the track used for timing.
2. Use an existing LRC if available. When given plain lyrics, run `lyrics-video.cmd align` on the vocal mix or a time-aligned clean vocal stem. This is a draft match against local Whisper recognition. Check skipped lines, repeated choruses, quiet words, timing drift, and English, Tagalog, or Taglish spelling by ear. Correct the LRC before delivery.
3. Pick a reusable style. Use `classic-videoke` for a color that accumulates across the sung words, `neon-stage` for the current word only, or `cinema-serif` for a softer lyric video. Keep lines short and legible at the destination size.
4. Run `lyrics-video.cmd render` on the final audio and the reviewed LRC. The tool writes an MP4 and editable ASS. Inspect the beginning, a chorus, and the last lyric. Leave intentional instrumental pauses blank.
5. Keep audio, lyric text, timing, and rendered video in the external project folder. Promote original style variations to the shared preset library when another project can reuse them.

See `tools/lyrics-video/README.md` for commands and timing format.
