# Video editors workspace

## Local-only policy

Agents author edit plans and reusable code, then run local tools. Never send footage, transcripts, assets, prompts, or credentials to OpusClip, HeyGen, hosted MCP, cloud rendering, or other hosted media APIs. Do not read or display vendor keys. HyperFrames runs through the local CLI and needs no API key. Preserve source videos and render new copies.

## Skills

Use the discoverable skills directly under `.agents/skills/`:

- Reels/Shorts editing: `shorts-production-local`, `opusclip-local`.
- Designed video and overlays: `hyperframes-local`, `hyperframes-overlays-local`.
- Podcast clips: `podcast-hooks-local` covers first-frame titles, spoken captions, and thumbnails.
- Editorial decisions: `editing-videos`. Advanced operations and validation: `ffmpeg-skill` and `video-editing-skill` via the Windows wrappers in `tools/agent-edit/`.

Do not nest skills under category folders; Codex discovers each skill as a direct child of `.agents/skills/`. See `.agents/skills/README.md` for the index.

## Workspace map

- `tools/ffmpeg/` — portable FFmpeg and ffprobe.
- `tools/captioning/` — local Whisper executable and English plus multilingual models.
- `tools/lyrics-video/` — offline lyric timing and videoke rendering. If singing is buried in the mix, try `tools/vocal-separation/` for a CPU vocal and accompaniment split before retrying Whisper.
- `tools/hyperframes/` — local HyperFrames CLI, Node runtime, and local-only wrapper.
- `tools/opusclip-local/` — agent-runnable Python/FFmpeg/Whisper workflow, including caption and zoom scripts; this is a local implementation, not OpusClip's service.
- `tools/media-lab/` — agent-runnable Python/FFmpeg tools for probing, audio extraction/cleanup/mixing, image finishing, reframing, and procedural sound creation.
- `tools/agent-edit/` — local wrappers for the imported editing tools and podcast hook/thumbnail rendering. Use the bundled runtimes and this workspace’s local-only policy when following upstream guides.
- `tools/python-video/` — private portable MoviePy runtime and an image overlay command. Use it for Python compositions.
- `tools/gl-transitions/` — native local shader transitions. Use it for effects such as CrossZoom and FilmBurn. See its README for the graphics check and render command.
- `tools/upstream-editing/` — additional editing skill packs for reference. Read individual guides as needed and use only their local steps.
- `assets/overlays/`, `assets/stickers/`, `assets/sound-effects/`, `assets/music/`, `assets/memes/` — reusable local libraries grouped by format or media type.
- `assets/captions/` and `assets/text/` — reusable caption styles, animations, and text collections.
- `industries/<industry>/` — briefs, transcripts, campaign notes, and industry-specific asset pointers.
- `projects/<project>/` — project files and working renders.
- `FILE_TREE.md` — generated complete file-by-file inventory; regenerate with `tools/inventory/build_tree.py` after reorganizing.

Use `.agents/skills/professional-local-editing/` as the routing skill for combined video/audio/image/caption requests. Captions and zoom still use the dedicated `opusclip-local` scripts; do not duplicate those workflows.

## Reusable asset growth

Before making a new reusable effect, sticker, overlay, caption/text style, sound cue, or animation, search `assets/` for an existing fit. Save genuinely reusable creations into the shared library, not only inside a campaign folder. Give each item a unique ID, useful tags, intended context, editable source where possible, and usage/provenance notes; update the relevant catalog or README. Keep campaign-specific files in the campaign folder and link to shared assets instead of duplicating them. Prefer local SVG/PNG, local fonts, and local audio; do not depend on CDNs or remote assets.

Keep actual video exports and project media in the user's external project folder. For the Clipping campaign, its previous Windows location was `C:\Users\Robel\Downloads\Clipping` and captioned copies went under `output\files\captioned`. After moving the toolkit to another PC, use that project's new location. Keep reusable guidance in `industries/hip-hop-clipping/`.

- `.agents/skills/brief2mp4-local/` — brief-to-motion-graphics, lyric videos, 82 art-form recipes, and frame-by-frame delivery checks. Use the PowerShell bridge in `tools/brief2mp4-local/` to reuse bundled FFmpeg, HyperFrames, Node, and Python.
- `tools/brief2mp4-local/vendor-cache/` — shared GSAP and Three.js browser files; optional project vendoring keeps generated projects offline and movable. See `NOTICE.md` for licenses.
