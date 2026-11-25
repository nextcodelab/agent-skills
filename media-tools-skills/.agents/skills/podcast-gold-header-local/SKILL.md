---
name: podcast-gold-header-local
description: Apply the Rajxpodcast reference style to vertical podcast clips using a black headline band, speaker close-up, and bold gold dialogue captions. Use when asked for that Short's style or a persistent header with gold word-timed captions.
---

# Podcast gold header

[Style reference](https://www.youtube.com/shorts/B1P6PE-13bc). The sampled opening and playback frames showed a centered white headline in a black band, a tight speaker shot, and bold gold words that changed with the dialogue. Create an original headline for each clip and use the project's own footage, captions, fonts, and sounds.

1. Select a close shot showing the speaker's eyes and expression. Set the output canvas to 1080×1920. For a centered starting layout, crop the shot to 1048×1296 and place it at x=16, y=304 on solid black. Adjust the shot crop around the speaker and keep the headline band free of footage. Example FFmpeg filter for square-pixel footage:
   ```text
   scale=1048:1296:force_original_aspect_ratio=increase:force_divisible_by=2,crop=1048:1296,pad=1080:1920:16:304:black,setsar=1
   ```
2. Run the local caption workflow on the framed clip with `assets/captions/styles/podcast-gold-closeup.json`. Keep the actual speech and review Tagalog, Taglish, or English names and timings. The preset uses short uppercase groups with gold word highlighting. If the crop places text on the mouth, adjust the preset's vertical margin for the clip before rendering.
3. On the captioned file use `tools/agent-edit/podcast-hook.cmd` with `--position header --full-length --text "Your own short headline"`. This puts the white headline within the black band from frame zero. For a brief hook, replace `--full-length` with `--seconds 2.2`. For a matching first-frame cover, add `--thumbnail` with a different output filename.
4. Check frame zero, a mid-clip frame, and the last frame for the requested title hold. Review the caption transitions at phone size and check that the right-side platform controls, faces, captions, and headline have clearance. Save output copies to the external project folder.

Keep the existing `podcast-hooks-local` style as the default for other podcast projects. Use the gold header style when the reference or look is requested.
