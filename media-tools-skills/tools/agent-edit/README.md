# Agent editing tools

Use [Explainer transitions](MOTION_TRANSITIONS.md) to animate between original graphic scenes with the local scan/slice and iris presets.

For transcript-timed object popups, see [Automatic mention timing](MENTION_OVERLAYS.md). Use `local-reel-production-system` for reference analysis, a repeatable edit plan, and the tool choices shown in the reel production reference.

Run these examples in PowerShell from the toolkit root. Use absolute paths for project media and outputs, and keep the project folder outside the toolkit.

```powershell
.\tools\agent-edit\ffmpeg-skill.cmd doctor --json
.\tools\agent-edit\ffmpeg-skill.cmd scenes --help
.\tools\agent-edit\ffmpeg-skill.cmd check --help
.\tools\agent-edit\timeline.cmd --help
.\tools\agent-edit\mediainfo.cmd --Output=JSON "D:\project\export.mp4"
.\tools\agent-edit\podcast-hook.cmd "D:\project\captioned.mp4" "D:\project\hooked.mp4" --text "Why the deal fell apart" --thumbnail "D:\project\hooked.jpg"
```

Use the bundled FFmpeg skill for trims, joins, silence detection, scene analysis, audio processing and delivery checks. Use the timeline runner for repeatable edits from structured requests. See the upstream README for the request shape and workspace options. Continue using the local Whisper pipeline for English, Tagalog, and Taglish captions.

[MediaInfo CLI 26.10](https://mediaarea.net/en/MediaInfo/Download/Windows) is bundled under `tools/mediainfo/` for detailed local inspection of video codecs, HDR and color metadata, audio channels, and subtitle tracks. Pass local filenames.

For podcast Shorts, render framing and dialogue captions first. Then add the opening hook and open the first frame of the result to check the hook, the speaker's face, and any dialogue captions. The optional thumbnail is the opening frame of the finished video. The helper re-encodes video and the first audio track, so use it on a finished single-audio-track copy with dialogue captions already burned in. It uses Windows Arial Bold.

For the gold podcast caption style, follow `podcast-gold-header-local` for the black header band and framing. Pass `--position header --full-length` to place the hook inside the preframed band and keep it visible throughout the clip.

## Upstream sources

| Project | Pinned revision | Location |
| --- | --- | --- |
| [Editing Videos](https://github.com/joshcirre/editing-videos) | `50326e094819f6748044651855f95abbe2bcc886` | `.agents/skills/editing-videos` |
| [FFmpeg Skill](https://github.com/kajisho5/ffmpeg-skill) | npm `4.7.1`, commit `bad487c5c4c1d3db52893b27d5ff1278da5274a8` | `.agents/skills/ffmpeg-skill` |
| [Video Editing Skill](https://github.com/kajisho5/video-editing-skill) | `2acdd7a190cc5414b5d68fdaa4828d6033524c13` | `.agents/skills/video-editing-skill` |
| [Video Editing](https://github.com/gitethanwoo/video-editing) | `8b633c2d698410e523f95335aa6433766264cc7f` | `tools/upstream-editing/gitethanwoo-video-editing` |
| [Video Editing Skills](https://github.com/iamaanahmad/agents-video-editing-skills) | `981466bde5d5044d08cb5af391770bfd16f9c4e4` | `tools/upstream-editing/iamaanahmad-video-editing` |

The last two packs are available as references, including their individual skill files. They contain workflows that may assume extra dependencies or online services. Follow the workspace's local-only policy and use the bundled tools for media processing. The workspace's own professional editing skill is the entry point.
