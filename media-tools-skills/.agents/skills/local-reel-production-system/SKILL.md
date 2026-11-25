---
name: local-reel-production-system
description: Turn footage and editing references into repeatable local Reels using a style profile, word-timed transcription, a structured edit plan, reusable graphics, and export review.
---

# Local reel production system

[Workflow reference](https://www.youtube.com/shorts/fTauJDVaUBw). The creator shows Claude Code coordinating Whisper, FFmpeg, HyperFrames, yt-dlp, and Klint AI, then grouping footage, assets, and edits by project and teaching the agent a style from examples.

| Tool shown | Use in this toolkit |
| --- | --- |
| Claude Code | Codex can coordinate the same local editing stages. Keep the plan with the project. |
| Whisper | Use the bundled Whisper models and caption workflow for timed transcript JSON, SRT, and ASS. |
| FFmpeg | Use the portable FFmpeg skill and timeline wrapper for cuts, framing, audio, rendering, and delivery checks. |
| HyperFrames | Use the bundled CLI for local motion graphics. Use FFmpeg or PNG overlays where Chromium cannot render. |
| yt-dlp | Optional network source acquisition for authorized material. Local files or inspected browser references are enough for this workflow. |
| Klint AI | The video shows it for Instagram trend discovery. Use the public references supplied for the project and keep source footage and project data in the local workflow. |

1. Inside the external project, keep `source/`, `assets/`, `edit/`, and `output/`. Use the toolkit's shared assets by path.
2. Sample reference frames and dialogue. Record the hook placement and hold, shot cadence, caption treatment, overlays, and audio cues in an editable style profile. Separate directly observed traits from choices made for this project. The Short's visible treatment includes top explainer graphics with the speaker below. Apply that composition when it fits.
3. Transcribe the raw clips locally. Choose the story from the transcript and footage, record each source range, then render the rough cut and establish final-cut timings.
4. Add the project headline, timed captions, graphics, and context inserts. Use `mention-overlays-local` if spoken objects or instructions benefit from a visual. Use project-owned copy and artwork.
   Use `contextual-visual-design-local` when an original illustration would explain the beat better. Pick a preset from `tools/agent-edit/MOTION_TRANSITIONS.md` when moving between designed scenes.
5. Review frame zero, representative captions and transitions, the ending, audio, and technical export settings. Save reusable style rules and broadly useful original graphics in the shared library. Keep each campaign's footage, one-off cutaways, and exports in its project.

Record these fields in the style profile: reference links, audience, hook and hold, shot cadence, crop, captions, graphic placement, audio treatment, and changes approved after review. See `tools/agent-edit/README.md` for local commands.
