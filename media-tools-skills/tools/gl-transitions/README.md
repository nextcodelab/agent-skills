# Local GL Transitions

The official GL Transitions 3.3.0 npm package is vendored in `catalog/` with its metadata and licenses. This Windows x64 CLI uses native wgpu to render the WGSL versions with an available graphics adapter, MoviePy to read clip frames, and the bundled FFmpeg to encode H.264/AAC. It runs locally without Chrome, a hosted renderer, or an API key.

```powershell
.\tools\gl-transitions\gl-transition.cmd list
.\tools\gl-transitions\gl-transition.cmd doctor
.\tools\gl-transitions\gl-transition.cmd render "D:\project\before.mp4" "D:\project\after.mp4" "D:\project\crosszoom.mp4" --effect CrossZoom --seconds 0.35
```

Try `CrossZoom` for radial zoom blur, `DirectionalWarp` for a quick sideways movement, `FilmBurn` for light spill, or `Cube` for a 3D turn. Use `list` for exact names. The wrapper exposes MIT effects with a compatible WGSL shader and no extra texture requirements. Effects use upstream parameter defaults. The original catalog retains its per-effect license notices.

The renderer fits both shots into a 1080×1920 canvas at 30 fps by default. Use `--width`, `--height`, and `--fps` for your project. Pre-crop shots if they should fill a different aspect ratio. The overlap shortens the output and crossfades available clip audio. It is designed for SDR clips. Finish separate music and caption tracks on the final timeline.

Run `doctor` after moving the toolkit to another Windows x64 PC. If adapter selection fails, try `doctor --backend D3D12` or `doctor --backend Vulkan`, then use the same option for `render`. Use the FFmpeg-only presets when GPU rendering is unavailable. [Upstream catalog](https://github.com/gl-transitions/gl-transitions).
