# Portable Windows toolkit

Copy the entire `video-editors` folder to a USB drive or another Windows x64 PC to carry the skills, local tools, projects, and reusable assets together. Keep the top-level folder structure intact: the `.cmd` wrappers resolve tool paths relative to their own location.

## What travels with the folder

- `.agents/skills/` — agent editing instructions.
- `assets/` — local stickers, text styles, captions, overlays, and presets.
- `tools/` — bundled FFmpeg, Python, Whisper, HyperFrames, Node, and scripts.
- `projects/` — editable project files, including the sample text-style reel.
- `FILE_TREE.md` — full generated inventory of every bundled file; run `tools/inventory/build_tree.py` to refresh it.

The local media lab provides Python/FFmpeg commands for media inspection, extracting audio, dialogue cleanup, music/SFX mixing, image finishing, and no-blur reframing. Original procedural cues and their catalog are in `assets/sound-effects/synthetic/`. English and multilingual Whisper models support the existing caption workflow; model size and hardware requirements travel with the folder.

This is currently a **Windows x64** bundle. System fonts are used as fallbacks, so typography can vary slightly between PCs. Include the local Whisper models if transcription must work offline; they use substantial disk space.

MoviePy and the GL Transitions catalog travel under `tools/python-video/` and `tools/gl-transitions/`. MoviePy uses the bundled FFmpeg. Shader rendering uses a compatible graphics adapter on the destination PC. See `tools/gl-transitions/README.md` for the local graphics check.

## HyperFrames browser requirement

The HyperFrames CLI, Node, FFmpeg, and Windows x64 Chrome Headless Shell travel in this folder. The wrapper resolves them from the toolkit path. Keep the complete `tools/browser/` directory with its DLLs and data. See its README for browser selection order.

Headless rendering depends on the destination PC's Chromium launch support. The existing sample MP4 was rendered with the FFmpeg fallback after browser issues. The editable HyperFrames project is under `projects/sample-text-style-test/`.

On macOS, Linux, or Windows ARM, carry over the skills, scripts, assets and projects, and supply runtimes for that platform. The bundled binaries and Windows command wrappers target Windows x64.

No vendor API keys or hosted rendering services are needed. Keep media local and pass an output path when rendering on a different PC.

The `brief2mp4-local` skill and its 2.1 MB of templates, scripts, and art-form recipes travel under `.agents/skills/`. It reuses the bundled FFmpeg, ffprobe, HyperFrames, Node, and Python through `tools/brief2mp4-local/brief2mp4.ps1`. Shared GSAP and Three.js files live under `tools/brief2mp4-local/vendor-cache/` and are copied into a render project only when needed for an offline, self-contained project. Check `vendor-cache/NOTICE.md` for their separate license terms. Blender, Git Bash, optional 3D CAD/physics packages, and image-to-3D models are not bundled. HyperFrames still needs its bundled headless browser, which has crashed on this PC before.
