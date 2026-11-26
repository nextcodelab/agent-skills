---
name: contextual-visual-design-local
description: Create original or source rights-cleared images, icons, diagrams, and mockups that explain spoken ideas in videos. Use for context-driven illustrations, visual metaphors, object popups, or animated explainer cutaways.
---

# Invent visuals from the edit

1. Read the transcript and inspect the surrounding shots. Pick beats where a visual makes the idea clearer or gives a joke its payoff. Write what the viewer should understand and choose a single image for that beat. Skip mentions that work well as dialogue alone.
2. Choose a form that fits the meaning of the spoken line, not only its nouns. A concrete object can become an icon or source-derived popup; a process can become a short diagram; a contrast can become a before/after card. Sensations, moods, reactions, and idioms can become simple visual metaphors or motion cues (for example, heat shimmer or an overheating symbol for an emphatic 'hot' reaction). Use surrounding speech and footage to choose the right interpretation, keep the speaker's tone, and avoid implying a literal event or unsupported fact.
3. Start with the project's media and the toolkit asset library. When neither fits, invent the image as a clean SVG with editable shapes, original artwork, and separate text, or find a rights-cleared source visual online. For simple labels and cards, HTML/CSS or FFmpeg drawing also works locally. If the scene calls for a photo, use a project-owned still, a properly licensed web image, or an installed local image generator. Mark an illustrative mockup clearly whenever viewers could read it as a real screenshot or proof.

### Web visuals and reuse rights

- Search any website or image library that may have a useful visual; do not limit discovery to a fixed site list. Search results and previews are discovery only. Open the specific asset's original source page and verify its reuse terms before downloading or editing it. Treat an image, animation, video, icon, sound, font, or other web asset as protected unless its rights are clearly stated or permission is documented.
- Prefer public-domain/CC0 material, or licenses that explicitly permit the intended distribution, editing, and commercial/client use. Check the exact license version and conditions. CC BY requires attribution; CC BY-SA has share-alike terms; avoid NonCommercial assets for client/promotional work and NoDerivatives assets when cropping, compositing, or animating could create an adaptation unless the rights holder grants permission. If terms are unclear or incompatible, choose another asset or create an original visual.
- Keep copyright and brand/person rights separate. A copyright license for a photo may not grant permission to use a logo, trademark, identifiable person, or imply endorsement. For branded marks, check the rights holder's current official usage rules; preserve required proportions, colors, clear space, and any limits on editorial use. Do not imply sponsorship or endorsement. If the intended use is not clearly permitted, use footage supplied by the user, a plain text mention, or an original generic illustration.
- Record each external asset in the project manifest: asset filename, creator/rightsholder, exact source-page URL, license and version or permission, required credit, modifications, and the date checked. Include attribution in the client-approved credit location. Do not describe an asset as copyright-free merely because it appears in search results or has a download button.
- Consult [Creative Commons reuse guidance](https://creativecommons.org/reusing-cc-licensed-content/) and [the license conditions](https://creativecommons.org/cc-licenses/) when using CC work. CC itself notes that search tools can surface content that is not CC-licensed, so verify the rights attached to the exact asset.
4. Check at phone size. Keep each image legible at a glance, reserve space for faces and captions, and coordinate the accent color with the project. Let metaphorical overlays read as expressive graphics rather than evidence when they are not literal footage. Keep the editable source alongside any transparent PNG render. With the local FFmpeg build, use the SVG decoder when available or rasterize through a local editor or browser. Use the existing HyperFrames workflow for authored animation where browser rendering works.
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
