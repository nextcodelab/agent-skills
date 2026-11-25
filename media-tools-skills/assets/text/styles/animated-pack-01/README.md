# Animated Text Pack 01

Twelve editable text styles with a shared seekable GSAP runtime and local SVG previews. Styles are data files; the spoken/title wording, font settings, colors, duration, and positioning can be changed per use. The SVG preview files are static design samples; the animation is defined by each preset's `animation.type` and performed by `runtime/gsap-text-animation.js`.

## Contents

- `presets/*.json` — the editable style settings and sample phrase.
- `runtime/gsap-text-animation.js` — local helper; the HyperFrames project supplies its own local GSAP instance. It returns a paused GSAP timeline so the scene can seek deterministically.
- `previews/*.svg` — portable transparent vector look previews.
- `catalog.json` — IDs, tags, paths, and animation names.
- `preview.html` — an at-a-glance local style board.

## Included looks

Impact Pop, Soft Slide, Typewriter, Word Stagger, Neon Flicker, Marker Swipe, Tracking Reveal, Bounce Emphasis, Split Rise, Clean Lower Third, Glitch Caption, and Outline Reveal.

## Use in a local HyperFrames scene

Copy the selected preset JSON and runtime into the project. Import `buildTextTimeline` from the local runtime and pass the scene's locally installed GSAP instance, a DOM text element, the JSON preset, and optional editable wording. Example:

```js
import { buildTextTimeline } from './assets/text-style-runtime.js';
const titleTimeline = buildTextTimeline(gsap, document.querySelector('#title'), preset, {
  text: 'The phrase for this clip',
  duration: 0.65
});
// Seek titleTimeline from the scene's master timeline at the chosen beat.
```

Each preset uses system font fallbacks only; replace font choices with fonts installed on the target machine. No CDN, remote fonts, or network resource is needed. Review the safe area and readability over footage before exporting. Use brief motion and keep text away from faces, captions, and platform controls.

When adding a style, make it meaningfully different, add searchable tags, update the catalog, include a preview, and note its best use. Do not inflate the collection with near-duplicates.
