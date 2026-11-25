---
name: podcast-hooks-local
description: Edit podcast clips and vertical shorts with a readable first-frame editorial hook, synced speech captions, and an optional matching thumbnail using local tools. Use when asked for podcast captions, hook text, first-frame titles, or covers.
---

# Podcast hooks and captions

1. Read the clip and transcript. Pick a brief hook that previews the clip's actual payoff. Use a quote only when the speaker says those words. Start on an expressive frame with the speaker visible.
2. Burn the hook into frame zero of each podcast Short by default. Hold it about 1.5–2.5 seconds, subject to the opening pace. Keep it readable immediately, away from the speaker's face, dialogue captions, and platform controls.
3. Generate or reuse timed dialogue captions through the local Whisper workflow. Keep the spoken wording and the language of the clip, including Taglish. Use restrained accent colors for key points and reserve active-word highlighting for an explicit karaoke style. Review names, timing, and line breaks.
4. Apply the hook after final framing and burned-in dialogue captions. Use `tools/agent-edit/podcast-hook.cmd` for a static title or local HyperFrames for authored motion. When a thumbnail is requested, export a matching JPEG/PNG. The helper can capture the first rendered frame.
5. Open the exported first frame and an early frame with both text layers. Confirm the hook is present on frame zero, readable at phone size, and clear of faces and subtitles. Check after the hold time that the hook disappears. If a thumbnail is delivered, open that file separately.
6. Save fresh copies in the user's project output folder. Record the hook text and video/thumbnail names in the batch manifest.

Use the parent workspace's local media policy. See `tools/agent-edit/README.md` for commands.

When the brief calls for the Rajxpodcast reference or a persistent black header with gold captions, use `podcast-gold-header-local` for the framing, preset, and title placement.
