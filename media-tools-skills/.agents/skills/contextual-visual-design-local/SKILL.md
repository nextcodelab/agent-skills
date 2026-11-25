---
name: contextual-visual-design-local
description: Invent original images, icons, diagrams, and mockups that explain spoken ideas in videos. Use for context-driven illustrations, visual metaphors, object popups, or animated explainer cutaways.
---

# Invent visuals from the edit

1. Read the transcript and inspect the surrounding shots. Pick beats where a visual makes the idea clearer or gives a joke its payoff. Write what the viewer should understand and choose a single image for that beat. Skip mentions that work well as dialogue alone.
2. Choose a form that fits the meaning. A physical object can become an original icon. A process can become a two or three step diagram. A claim about a difference can become an editable before/after card. An abstract idea can become a visual metaphor, such as a countdown dial for a closing decision window.
3. Start with the project's media and the toolkit asset library. When neither fits, **invent the image** as a clean SVG with editable shapes, original artwork, and separate text. For simple labels and cards, HTML/CSS or FFmpeg drawing also works locally. If the scene calls for a photo, use a project-owned still or an installed local image generator if available. Mark an illustrative mockup clearly whenever viewers could read it as a real screenshot or proof.
4. Check at phone size. Keep each image legible at a glance, reserve space for faces and captions, and coordinate the accent color with the project. Keep the editable source alongside any transparent PNG render. With the local FFmpeg build, use the SVG decoder when available or rasterize through a local editor or browser. Use the existing HyperFrames workflow for authored animation where browser rendering works.
5. Time the visual to the beat in the final cut. Use `mention-overlays-local` to propose exact timing for selected spoken aliases. Use timed PNG compositing for a popup, a short cutaway for a detailed image, or `tools/agent-edit/motion-transition.cmd` when the visual replaces the scene. Preserve narration across the reveal when the scene is an explainer.
6. Review both the story and the export. Keep campaign-specific illustrations with that project. Promote only genuinely reusable originals, such as a generic dial or layout, to the shared library and include editable source, usage notes, and provenance.

## Examples for agents

| Spoken idea | Original image to make | Entrance |
| --- | --- | --- |
| A decision window is closing | Simple dial with a shrinking wedge and clear endpoint | Quick pop on the key word |
| This is how three steps work | Three boxes and a route that lights one step at a time | Reveal each step on its spoken cue |
| The first version and the result are different | Two original interface cards with one difference highlighted | Scan the first card and reveal both side by side |
| A budget is shrinking | Three paper bills narrowing into one stack | Brief cutaway and a quiet click |

Use the edit's language for labels. Leave measurements and proof claims out when the footage or supplied evidence cannot support them. See `tools/agent-edit/MOTION_TRANSITIONS.md` for the reference-inspired transitions.
