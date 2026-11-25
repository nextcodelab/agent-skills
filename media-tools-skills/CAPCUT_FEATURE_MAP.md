# CapCut-style capabilities in the local agent toolkit

This is a practical roadmap for building familiar timeline-editor operations into an offline, movable toolkit. It maps broad features CapCut describes for desktop editing to the local agent-run tools here; it does not promise exact parity with proprietary CapCut features. Product availability varies by CapCut version/account/region. The local workflow keeps media and transcripts on this PC.

## Available now

| Editing task | Local implementation | Current boundary |
| --- | --- | --- |
| Inspect source streams, duration, size, frame rate | `tools/media-lab/media-lab.cmd probe` | Reports metadata; editorial selection is agent-led. |
| Extract video audio | `media-lab.cmd extract-audio` | WAV/MP3/M4A/AAC outputs. |
| Reduce steady noise, shape voice, normalize and fade | `media-lab.cmd audio-finish` | FFmpeg filters; not AI source separation or restoration. Listen after processing. |
| Add a quiet music or SFX bed | `media-lab.cmd mix-bed` | Preserves source video and mixes its audio with a local asset. |
| English, Tagalog, and Taglish/code-switched transcription | `tools/opusclip-local/caption-batch.cmd` + local Whisper | Word timings, transcript JSON/TXT, SRT/ASS, styled captions; review model errors by hand. |
| Active-word karaoke and topic color highlights | Caption workflow and reusable `assets/captions/styles/` | Topic highlights depend on transcript/emphasis rules; verify spelling and intent. |
| Portrait zoom/punch moves without blurred fill | `tools/opusclip-local/zoom.cmd` | Existing zoom presets; does not identify a speaker automatically. |
| Clean portrait/square/landscape crop or contain/pad | `media-lab.cmd reframe` | Fixed crop; no automatic subject tracking. |
| Image resize, crop/contain, restrained grade/sharpen | `media-lab.cmd image` | Filter-based still image operations. |
| Reusable animated captions, text, stickers, overlays | `assets/` plus `hyperframes-local` and `hyperframes-overlays-local` skills | Prefer local editable SVG/JSON; HyperFrames browser rendering depends on this PC's Chromium setup. |
| Generate original short cue sounds | `tools/media-lab/synth-sfx.cmd` | Procedural piano-inspired tones, impact, sparkle, whoosh; not recorded instruments. |
| Local MP4 export | Bundled FFmpeg | Agents choose dimensions, quality, codec through documented commands. |

## Add next as portable modules

Implement one focused Python/FFmpeg/model tool at a time, with command help, a reusable preset/catalog, examples, and review instructions:

1. **Timeline edit-plan format**: JSON for source ranges, clip order, overlay time ranges, transforms, caption tracks, audio ducking, transitions, and export settings. Render consistently with FFmpeg; keep editable inputs beside the manifest.
2. **Beat and silence assist**: local audio analysis to propose beat markers, pauses, and cut suggestions. Keep suggestions reviewable; let the editor/agent choose cuts rather than making opaque automatic edits.
3. **Tracking and smart reframe**: add an offline face/person detector/tracker model, cache tracking data per source, expose a manual focus override, then render crop keyframes. Not yet bundled.
4. **Keyframe/easing library**: shared JSON curves for position, scale, opacity, rotation, and masks, rendered by FFmpeg expressions or a local HyperFrames scene.
5. **Transition/effect packs**: local recipes for speed ramps, blur/flash/whip transitions, masks, outlines, glows, freeze frames, and chroma key. Profile the actual bundled FFmpeg filters before adding recipes.
6. **Voice isolation and diarization**: optional downloadable offline models with explicit licenses, sizes, language coverage, hardware requirements, and no-network runtime. Current `afftdn` cleanup cannot isolate speech from music.
7. **Background removal and stabilization**: optional local segmentation and motion-estimation models; record model licenses and GPU/CPU requirements. Current reframe is not object-aware and is not stabilization.
8. **Editable project interchange**: a portable timeline schema plus rendered previews, so agents can revise cuts/captions without regenerating unrelated media.

Avoid a giant monolithic script. Keep each operation callable, documented, non-destructive by default, and reusable across industries. `.agents/skills/professional-local-editing/SKILL.md` is the routing entry point. Use desktop computer controls only for operations that genuinely need a graphical editor or visual inspection; scripts are the deterministic local rendering layer.

## Feature references

CapCut's own desktop/editor guides describe auto captions, keyframes, motion tracking, background removal/chroma key, reframe/stabilization, voice enhancement, and vocal isolation. These are roadmap categories, not claims that this local bundle implements every function.

- [CapCut PC professional video editor](https://www.capcut.com/resource/pc-professional-video-editor)
- [How to use CapCut on PC](https://www.capcut.com/resource/how-to-use-capcut-on-pc)
- [CapCut editing guide: effects, reframing, tracking, and audio](https://www.capcut.com/resource/how-to-use-capcut)
