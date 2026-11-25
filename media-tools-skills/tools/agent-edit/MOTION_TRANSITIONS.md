# Explainer transitions

The supplied local reference showed a pink scan moving over a card followed by a brief horizontal slice effect into a comparison, around 2.6 seconds. Around 21 seconds, a small round opening revealed a light scene. The presets below recreate the basic moves with bundled FFmpeg. Build your own scene images, labels, and comparisons.

```powershell
.\tools\agent-edit\motion-transition.cmd "D:\project\before.mp4" "D:\project\comparison.mp4" "D:\project\reveal.mp4" --preset scan-slice --scan-window 0.15 0.30 0.70 0.35
.\tools\agent-edit\motion-transition.cmd "D:\project\dark.mp4" "D:\project\light.mp4" "D:\project\iris.mp4" --preset iris-open
```

| Preset | Default | Use it for |
| --- | --- | --- |
| `scan-slice` | 0.20 s plus 0.32 s lead-in | Scan an outgoing interface card, then slice into its result or comparison. |
| `iris-open` | 0.30 s | Open a round window to reveal a new illustration or scene. |
| `clean-dissolve` | 0.25 s | Move between related scenes with gentle motion. |
| `side-push` | 0.24 s | Step through cards in left-to-right reading order as the current card leaves to the left. |
| `vertical-push` | 0.24 s | Move upward from one panel or item to the next. |
| `soft-sweep` | 0.35 s | Shift between two layouts with a smooth horizontal reveal. |
| `diagonal-wipe` | 0.23 s | Reveal a short callout or a new section with a diagonal edge. |
| `zoom-reveal` | 0.23 s | Move into an explanatory detail or an enlarged object. |
| `horizontal-blur-reveal` | 0.20 s | Smear the image horizontally across a fast cut. |
| `blur-zoom-reveal` | 0.20 s | Combine the sideways smear with an incoming 12% center zoom that eases back to normal. |
| `chapter-fade` | 0.45 s | Give a distinct section change or tonal reset some room. |

Select any row with `--preset` and adjust its hold with `--seconds`. The renderer defaults to 1080×1920 at 30 fps and fits inputs with solid black padding. It crossfades available clip audio unless you pass `--narration` with a continuous local audio track aligned to the combined cut. The scenes overlap for the duration of the transition, so use the resulting timeline for final caption and popup timings. A cut is also a good choice when an effect would distract from the speech.

If a graphic appears over an otherwise continuous shot, use timed compositing instead. Draw the original visual for the idea first, then choose a motion that helps the viewer follow it.

Preset source: `assets/effects/presets/explainer-transitions.json`.

For shader effects such as CrossZoom, DirectionalWarp, FilmBurn, and Cube, use the local [GL Transitions wrapper](../gl-transitions/README.md).
