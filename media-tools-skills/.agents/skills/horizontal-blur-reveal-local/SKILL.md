---
name: horizontal-blur-reveal-local
description: Apply a short sideways blur between shots or combine it with an incoming zoom settle. Use for a motion-smear transition, a caption that blurs with the shot, or the Damon Salvatore TikTok reference.
---

# Horizontal blur reveal

Around 0:05 in the [reference edit](https://www.tiktok.com/@pxmpee/video/7692709047962733844), the outgoing scene and its yellow caption smear sideways into a brighter close-up. The local presets recreate the blur and provide an optional zoom settle.

1. Choose an outgoing and incoming clip. Leave several usable frames on both sides of the join. For a continuous music sequence, align the transition midpoint with the beat and use the combined cut's music track through `--narration`.
2. Apply `horizontal-blur-reveal` for the sideways blur or `blur-zoom-reveal` to have the incoming frame start slightly tighter and ease back. Use the native composition or a deliberate crop. Set width and height equal for a square output, or use the default portrait canvas.
3. If the outgoing text should smear, burn it into the outgoing clip first. Apply only subtitles meant to stay sharp after the join. Treat the brighter incoming grade or eye glow as separate creative choices.
4. Review the cut at normal speed. Keep the smear short and check that the incoming face stays in frame during the optional center crop. Account for the overlap when timing remaining captions.

From the toolkit root:

```powershell
.\tools\agent-edit\motion-transition.cmd "D:\project\outgoing.mp4" "D:\project\incoming.mp4" "D:\project\blur-reveal.mp4" --preset blur-zoom-reveal
```

The transition defaults to about 0.20 seconds. Adjust with `--seconds` if the beat needs a tighter or longer overlap. See `tools/agent-edit/MOTION_TRANSITIONS.md`.
