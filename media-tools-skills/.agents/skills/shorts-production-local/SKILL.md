---
name: shorts-production-local
description: Turn existing long-form footage into a planned batch of captioned vertical Shorts using local transcripts, FFmpeg, and local rendering tools. Use for multi-clip Reels, TikToks, and Shorts production; for a single ad hoc cut, use opusclip-local.
---

# Shorts Production Local

Use this skill to turn existing footage into a reviewable batch of short vertical videos on this computer. The agent handles the editing plan, local rendering, filenames, manifests, and quality review.

## Local tool policy

- Use local source files and local tools such as FFmpeg, ffprobe, Python, local speech recognition already installed, and HyperFrames when the requested design needs it.
- Never send footage, transcripts, project files, prompts, or API keys to OpusClip, HeyGen, cloud rendering, hosted MCP, or another hosted media service.
- Do not read or display vendor credentials. An agent does not replace an API key; local commands render without one.
- Keep the original source untouched. Use a new destination and do not overwrite existing exports unless the user explicitly asks.


## Style modes

Keep the regular clean-caption and selective-popup treatment as the default. When a user supplies a style reference or asks for varied real-object popups and evidence cutaways, also read `../local-reel-production-system/SKILL.md` and its [object-led split Reel mode](../local-reel-production-system/references/object-led-reel-mode.md). This is an optional visual style for Reels/Shorts; it does not change the requested clip count, language, duration, or delivery format.

## Workflow

1. Inspect the source’s duration, frame size, frame rate, audio tracks, and available transcripts. Prefer a transcript already in the project; use local ASR only when installed and needed.
2. Follow the user’s requested count, duration, platforms, language, and output path. For highlight selection, choose distinct, self-contained moments with a clear hook and payoff; retain source in/out timestamps. If the request clearly authorizes rendering, proceed without an unnecessary approval pause.
3. Keep one batch organized: project files and scripts under `projects/<project>/`; base Shorts under `outputs/<title>/files/`; enhanced copies under `outputs/<title>/enhanced/`; keep the source in `raw/` unchanged. Use meaningful filenames and write a CSV manifest mapping clip number, title, source in/out, duration, and file path.
4. Reframe each landscape clip into a true 9:16 crop. Choose a focal position for the active person/action per clip, preserve aspect ratio, and avoid blurred side fill when the brief calls for a clean vertical crop. Use smooth, restrained zoom moves only when requested or useful; do not introduce abrupt camera motion.
5. Keep caption wording faithful to the spoken language, including Taglish when present. Use transcript timestamps when available. Check for burned-in source subtitles before adding new captions; crop them out where appropriate or position new captions to avoid overlap. Animate captions only to the degree requested and keep them readable in the platform safe area.
6. Render deterministic edits locally with FFmpeg. Use HyperFrames for HTML/CSS/GSAP motion design or transparent overlays, then composite locally when appropriate. Preserve source audio unless the user asks for a change.
7. Review the batch. Use ffprobe to check each file’s duration, dimensions, frame rate, audio, and codec; make a contact sheet to scan crop, captions, and titles; inspect representative frames and playback. Fix technical problems before delivery.
8. Deliver the output folder, manifest, any requested reusable prompt or skill, and a brief summary of settings and tool choices. Do not imply the clips were published when they were only rendered.

For the detailed edit and output checks, read [production workflow](references/production-workflow.md). For HyperFrames overlays, use `hyperframes-overlays-local`.

For podcasts, also use `podcast-hooks-local`. Put a readable editorial hook on frame zero, inspect its placement with dialogue captions, and create a matching thumbnail when requested. Record the actual opening text in the delivery manifest.



