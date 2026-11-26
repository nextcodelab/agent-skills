# Object-led split Reel mode

Use this as a distinct visual mode for short vertical edits when the user supplies the Nate Herk Short, asks for real-object popups, or wants the edit to change visual form with the story. It adds variety to the existing caption-and-context-popup mode; it does not replace it or force every clip to use a split screen.

Reference: [Claude has completely changed how I edit videos](https://www.youtube.com/shorts/CV-k6rPJvJY), by Nate Herk. The inspected Short alternates the presenter with relevant insert scenes: a command line, code/timeline views, an animated logo, an audio-level chart, and a montage of edit frames. Its captions keep one boxed treatment while selected words get an accent color. The useful pattern is the changing evidence and cutaway form, not copying its exact branding or using its graphics as project assets.

## Visual grammar

- Keep the speaker or main action as the story anchor. Choose overlays from the meaning of the spoken beat: a literal object/action/place when that helps, or a visual metaphor for a sensation, mood, reaction, comparison, or idiom. Use surrounding context to pick the interpretation; keep expressive graphics recognizable as graphics, not footage or proof.
- Build several distinct beats across the finished Short when the story supports them. Vary the visual form and entrance path: a real-object cutout that grows from its source position; a side-docked evidence card; a quick detail crop; a short full-screen B-roll cutaway; an animated diagram; or a reaction stamp/meter. Do not make one static location card the repeated treatment, and do not add a popup for every noun.
- For a real-object popup, use a project-owned still/cutout or a frame from the actual footage. If a clean alpha cutout is unavailable, use a tight crop, a tracked outline, or an explicitly illustrative SVG instead of fabricating a photographic object that could be mistaken for the real one. This toolkit has no bundled automatic background-removal model.
- Let the object appear to come from the object or screen region it refers to, then travel to a clear safe lane. A short scale-up with a slight overshoot and settle can make it feel tactile; exit with a scale-down, return-to-anchor, or a different purposeful wipe. Use seekable GSAP transforms in HyperFrames for this. Do not reuse the same direction and landing position on every beat.
- Use the available frame, face, gesture, caption, and platform-safe areas to choose the landing position per shot. Do not cover a face, hands demonstrating the object, or dialogue captions. One prominent popup at a time is the default; overlapping is for a deliberate layered montage only.
- Keep dialogue captions in a stable lane and style. Give highlighted spoken words a consistent accent treatment; let object art, proof inserts, and reaction graphics have their own visual language without turning each caption into another popup.
- Choose reactions that match the speaker's actual response. Do not add an unsupported rating, quote, product claim, or emotion label.

## Motion variation and landing positions

- Make each selected popup feel distinct. Mix rotations, fades, scale changes, slides, short arcs, and gentle drift; vary direction, speed, and hold. For example, one object can rotate and scale up from its source anchor, another can slide in quickly with a soft fade, and another can drift in slowly before a short fade-and-tilt exit. Use fast and slow beats across the reel instead of making every popup bounce the same way.
- Inspect the actual frame at each beat and choose a currently open landing zone from the safe parts of that shot. Move between left, right, upper, or lower lanes as the composition allows; account for the speaker, demonstrated hands, product, captions, and platform controls. Do not use a fixed screen position or move an overlay to a randomly chosen place that collides with content.
- Rotate only enough to add energy while keeping labels and object details readable. Give entries and exits their own motion; exits can fade while rotating, scale away, slide out, or return toward the source anchor. Avoid repeating the same entry, landing position, and exit on adjacent beats.
- Randomized creative choices must be stable for a render: select from authored motion/position options once using a project or clip seed, then record each choice in the effects manifest. Keep the GSAP timeline seekable; do not call `Math.random()` or depend on wall-clock timing inside the timeline.

## Agent workflow

1. Inspect the final clip, local transcript, and supplied reference. Write a small style profile noting which reference traits were observed and which are being adapted. Lock the cut before timing effects.
2. Choose only high-payoff object/action/fact/reaction beats. Use exact word timing from local Whisper when possible. Confirm the language from speech; add Tagalog/Taglish only when it is spoken.
3. Create an overlay plan with the matched phrase, final-cut start/end, visual asset, source anchor, landing safe zone, entry/exit motion, and whether it is an insert or stays over A-roll. `mention-plan.cmd` proposes times/placement from the selected aliases; the agent still chooses and checks the image and motion.
4. Search project assets and `assets/` before making artwork. For an actual object, prefer the source frame or a project-supplied cutout; if those are missing, search any suitable web source and verify rights for the exact asset before use. For an explanatory visual that is not a literal object, use a verified rights-cleared web visual or make an editable local SVG/HTML illustration, and label a mockup when it could be read as evidence. Record source, license/permission, and attribution in the asset manifest. Follow `contextual-visual-design-local` for reuse checks; do not assume logos, people, or branded packaging are cleared by a photo license.
5. Animate designed overlays with local HyperFrames/GSAP using deterministic timelines and a transparent root; render a short transparent WebM. Use the local alpha-aware FFmpeg workflow in `hyperframes-overlays-local/references/local-overlay-rendering.md` and inspect one composite before using the look throughout a batch.
6. Use the transition runner only when the visual replaces or transforms a scene. Keep continuous speech/audio aligned and retime captions/effects after the transition changes the cut.
7. Review at phone size: inspect popup entry, landing, hold, and exit; check the full phrase timing, face/gesture visibility, caption collisions, and varied composition. Record exact final timings and asset paths in the effects manifest.

## Local agent tool map

Run commands from the toolkit root, with project files and exports in the user's project folder. Use the bundled wrappers; do not rely on network-fetched packages or hosted renderers.

| Need | Agent tool and role |
| --- | --- |
| Local transcript, word timing, ASS/SRT | `tools/opusclip-local/caption-batch.cmd` and the bundled Whisper model. Use `--language auto` for mixed English/Tagalog speech, then manually correct names and code-switching. |
| Mention timing | `tools/agent-edit/mention-plan.cmd`; pass word JSON, selected alias rules, output plan, and clip duration. It finds words; it does not generate images or animate them. |
| Original motion graphics, object cutouts, animated cards | `tools/hyperframes/hyperframes-local.cmd` with bundled HyperFrames and project-local GSAP. Check the local wrapper's `render --help`; follow the transparent WebM and alpha-check procedure in `hyperframes-overlays-local`. |
| Place a prebuilt transparent PNG | `tools/python-video/moviepy-overlays.cmd`; use for a timed still layer. It does not create animated zoom/rotation. |
| Scene-to-scene motion | `tools/agent-edit/motion-transition.cmd`; consult `tools/agent-edit/MOTION_TRANSITIONS.md` for `zoom-reveal`, `iris-open`, `side-push`, `clean-dissolve`, and other supported presets. Use on adjacent scenes/cutaways, not as a substitute for animating an object over continuous A-roll. |
| Optional GPU shader transition | `tools/gl-transitions/gl-transition.cmd`; use `doctor` first and choose only a locally supported effect. |
| Probe, composite, and export checks | Bundled `tools/ffmpeg/bin/ffmpeg.exe`, `ffprobe.exe`, plus `tools/agent-edit/ffmpeg-skill.cmd` for the local editing workflow. |
| Existing reusable overlays | Search `assets/overlays/`, `assets/stickers/`, `assets/animations/`, `assets/captions/`, and the current project before creating another asset. |

The mention planner selects times, the local art/source media supplies the visual, HyperFrames animates it, and FFmpeg composites it with the finished clip. Keep those responsibilities separate so an agent does not mistake a timing plan for a rendered popup.
