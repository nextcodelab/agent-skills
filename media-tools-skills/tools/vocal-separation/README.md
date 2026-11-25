# Local vocal separation

This Windows x64 tool splits a music mix into vocals and accompaniment using the CPU. The 28.3 MiB `UVR_MDXNET_9482.onnx` model and sherpa-onnx CPU runtime stay inside this folder. The tool uses FFmpeg for input conversion. It runs locally without an account, a GPU, or an API key.

```powershell
.\tools\vocal-separation\separate-vocals.cmd "D:\song\mix.mp3" "D:\song\vocals.wav" "D:\song\backing.wav"
.\tools\lyrics-video\lyrics-video.cmd align "D:\song\vocals.wav" "D:\song\lyrics.txt" "D:\song\draft.lrc" --language tl
```

Use one or two CPU threads on a machine with limited memory. A separated vocal stem can contain backing artifacts or lose some singing. If the source is instrumental, a separator will not create words. Review the lyrics against the original audio before rendering. To make a sing-along, export against the backing stem only after checking its timing and sound quality.

Agents can call `separate(source, vocals, backing, threads=2)` in `separate.py` from a Python script. Add this folder to that script's import path, or call `separate-vocals.cmd` as a subprocess. The wrapper uses only Python's standard library.

The runtime is [sherpa-onnx v2.0.3](https://github.com/k2-fsa/sherpa-onnx/releases/tag/v2.0.3). Use the [sherpa-onnx source separation model files](https://k2-fsa.github.io/sherpa/onnx/source-separation/models.html) with its expected metadata. The model download and Windows runtime were verified against their GitHub release SHA-256 digests.
