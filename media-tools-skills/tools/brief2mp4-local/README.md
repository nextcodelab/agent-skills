This folder is a Windows x64 adaptation of brief2mp4 for the portable video-editors workspace. `brief2mp4.ps1` routes rendering to the existing local HyperFrames wrapper and finishing/checking to the existing FFmpeg and ffprobe. It never installs runtimes or contacts a hosted rendering service.

The shared GSAP 3.15.0 and Three.js 0.170.0 files are cached here once. Run `scripts/vendor_libs.ps1 -Project <existing-project> -Three` to copy them into a project's `vendor/` directory for offline rendering. See `vendor-cache/NOTICE.md` for their distinct terms. The source skill, templates, art-form guides, character kit, and Python utilities live at `.agents/skills/brief2mp4-local/`.

Upstream source was taken from commit `641682e3b808b6e3ee75619770572fdb5a94b5bc` (2026-11-24). The toolkit integration and PowerShell bridge are local adaptations.
