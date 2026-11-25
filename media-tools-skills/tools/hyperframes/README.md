# HyperFrames, local CLI

HyperFrames is installed under `app/node_modules/` with the portable Node runtime under `runtime/`. Agents author and update the video code, then run this local CLI through `hyperframes-local.cmd`.

Examples:

```powershell
.\hyperframes-local.cmd --version
.\hyperframes-local.cmd init .\projects\sample --skip-skills
.\hyperframes-local.cmd render --help
```

The wrapper uses the bundled Node and FFmpeg and selects a browser under `tools/browser/` when available. See `tools/browser/README.md` and `PORTABILITY.md` for copy instructions and browser paths. Local rendering needs no API key. `app/package-lock.json` pins the installed package set.
