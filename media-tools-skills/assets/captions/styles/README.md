# Caption style library

Each style is a JSON preset used by `tools/opusclip-local/scripts/caption_batch.py`. Add variants here instead of hard-coding looks in scripts. Use `catalog.json` to tag each style by language, mood, format, and animation.

Starter styles: `podcast-clean-highlight`, `karaoke-lyrics`, `minimal-white`, and `pop-word-highlight`.

To add a reusable style, copy `style-template.json`, give it a unique ID, describe when another agent should choose it, and register it in `catalog.json`. Include supported languages, placement, typography, color/outline, highlight mode, and animation. Preview it on real footage and save a contact sheet/sample in the project before calling it ready. Do not add near-duplicates just to inflate the count; grow the library with styles that help other projects.
