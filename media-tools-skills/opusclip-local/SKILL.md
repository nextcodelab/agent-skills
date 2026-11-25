---
name: opusclip-local
description: Analyze and edit source videos into short-form social clips with local-first tools such as FFmpeg and Whisper. Use for highlight selection, clipping, captions, reframing, cleanup, overlays, branding, batch export, and publishing preparation; external publishing requires explicit user authorization.
---

# OpusClip Local

## Local-only agent rule

Use this skill with the agent and local tools on this computer. Do not call OpusClip websites, APIs, cloud editors, or hosted transcription/generation services. Do not read, print, or use OpusClip or other vendor API keys. Use local FFmpeg and available local speech tools; if an operation would require a hosted provider, explain the local limitation and offer a local alternative.


Create polished short-form edits from footage using tools available on the user's machine. Reproduce the editing workflow and feature set of an AI clipping editor; do not claim to reproduce OpusClip's proprietary models or scores.

## Workflow

1. **Understand the brief.** Identify source files, desired platforms/aspect ratios, clip count and duration, language, caption style, brand assets, output location, and whether the user wants suggestions, drafts, or final exports. Infer routine defaults from the request and footage. Ask only when a missing choice materially changes the result.
2. **Inspect the media and tools.** Check file metadata, duration, dimensions, frame rate, audio streams, and orientation with available local utilities (prefer `ffprobe`). Check which of FFmpeg, Whisper-compatible transcription, and optional local vision/speech models are installed before relying on them. Keep originals untouched and write new exports to the requested destination or a clearly named output folder.
3. **Analyze before editing.** For short clips, inspect the footage directly. For long videos, use local transcription when available, then identify candidate moments by topic changes, complete thoughts, strong openings, emotional emphasis, demonstrations, and useful endings. If transcription or AI models are unavailable, use available tools and make the limitation clear; never invent transcript content or automated certainty.
4. **Propose or select clips.** Follow the user's requested number and duration. Otherwise produce a small, useful set of distinct candidates, favoring self-contained moments with context and a clear hook. Rank candidates using transparent editorial heuristics—hook, clarity, pacing, payoff, and standalone context—not fabricated platform performance or proprietary virality scores. Keep timestamps so every edit is traceable to the source.
5. **Edit and render.** Make the requested cuts, reframing, captions, cleanup, titles, overlays, and branding. Prefer non-destructive commands/projects or new output files. Use FFmpeg for deterministic media transforms; use local speech recognition or other local models only when installed and appropriate. Preserve intelligible original audio unless asked to change it.
6. **Review the exports.** Check that each file opens, has expected duration, aspect ratio, frame rate, audio, and captions. Inspect representative frames and listen to the start/end when practical. Fix clipped words, black gaps, bad crop positions, subtitle collisions, audio pops, or encoding issues before delivery. Report any remaining quality limitation plainly.

## Capabilities

- **Highlights and clip plans:** Find and rank candidate moments; provide source in/out timestamps, rationale, suggested hook, and target duration.
- **Short-form cuts:** Trim, split, reorder, duplicate, combine, and batch-export clips, normally as MP4 when suitable.
- **Captions:** Transcribe with a locally available Whisper-compatible tool when possible; create timed subtitle files or burn-in captions. Keep wording faithful to the audio, preserve names where known, and synchronize to speech. Use word highlighting or animation only when the rendering approach supports it cleanly.
- **Vertical reframing:** Convert to 9:16, 1:1, or other requested aspect ratios. Keep the active speaker or important action in frame; use face/speaker tracking only when an available local tool supports it. Otherwise choose a sensible static crop and inspect it across the clip. Do not stretch footage to fill a frame.
- **Speech cleanup:** Detect and reduce long silences or filler words only when requested or clearly part of the brief. Preserve natural pauses and sentence boundaries; preview cuts for abrupt edits and audio artifacts.
- **Hooks, titles, B-roll, and graphics:** Suggest opening titles, add supplied or user-approved visuals, and place readable overlays with safe margins. Do not source, fabricate, or insert unrelated footage without user direction. Keep text legible on mobile.
- **Branding:** Apply provided logos, colors, and fonts. If assets or brand rules are missing, use a restrained default or ask for assets when they materially affect the result. Do not invent an official brand identity.
- **Timeline and batch work:** Make requested timeline changes and create multiple named exports from one source using consistent settings. Keep a concise mapping of each output to its source and timestamps.
- **Publishing preparation:** Create platform-ready files and, if useful, draft titles, descriptions, and hashtags. Do not upload, publish, schedule, or message through a connected account unless the user explicitly authorizes that external action.

## Editing guidance

- Make edits that serve the brief; do not add every capability to every video.
- Preserve the source's intended meaning and continuity. Avoid edits that change a speaker's meaning by removing context.
- Use platform limits or export specifications only when requested or verified from current authoritative documentation; otherwise state the chosen resolution, frame rate, and codec.
- Keep captions away from faces, important graphics, and platform interface areas. Use line breaks and duration that remain readable on a phone.
- Prefer local processing and existing source footage. Avoid uploading media to cloud services or sending it to third parties unless the user explicitly asks for that service.
- Do not remove attribution, watermarks, or ownership marks from footage unless the user confirms they own or are authorized to edit that source. When authorized, choose the least destructive method and disclose visible artifacts.
- Do not overwrite source media. Use clear filenames and retain edit parameters or intermediate assets only when they help the user revise the result.

## Delivery

Provide links to the finished exports and a brief summary of the edits. For highlight-selection tasks, include timestamps and selection rationale even if no render was requested. State which local tools were used and disclose unavailable requested capabilities or visible artifacts. Keep drafts and final files distinct, and do not imply that content was published when only export files were created.

