---
name: mention-overlays-local
description: Add local object popups, app cards, explanatory inserts, and B-roll timed to spoken mentions. Use for automatic contextual visuals and selective reuse of original overlay assets.
---

# Mention overlays

[Editing reference](https://www.youtube.com/shorts/EVaEcG7tMfg). The sampled frames showed a timeline cutaway, a search illustration, and a folder callout supporting specific instructions. Use assets from the current project or the shared local library.

1. Freeze the cut order before timing overlays. Use word timestamps measured on the final cut, or remap all source timestamps to that cut.
2. Pick spoken beats with a visual payoff: a named object/app/place, an action, sensation, mood, reaction, or idiom that benefits from a visual. Read the surrounding line and footage to choose literal imagery or a fitting metaphor; handle negation, repeated mentions, and homonyms. Keep expressive graphics distinct from factual proof. Write only selected aliases into the rules JSON. Add English, Tagalog, or Taglish variants when the transcript actually uses them.
3. Search the project and `assets/` first, then search any suitable web source if a relevant visual is missing. For literal mentions, use a matching source image; for nonliteral wording, use an original or rights-cleared visual metaphor that fits the line's meaning and tone. Verify reuse rights for the exact asset before download or adaptation, including commercial/client use, editing rights, attribution, and brand/person restrictions. Record source URL, creator, license/permission, credit, and changes in the asset manifest. If rights are unclear, create an original visual or use project footage. See `contextual-visual-design-local` for the web reuse checklist.
4. Run `tools/agent-edit/mention-plan.cmd` to match the aliases to spoken timestamps. Review its proposed times and placement against the playback. Use the FFmpeg skill for timed static PNGs or B-roll and HyperFrames for designed motion. Keep each popup around the mention, avoid covering faces and captions, and use quiet sound only when it helps.
5. Promote only assets that work across projects, have clear provenance, and have editable source where practical. Give them an ID, tags, and a library entry. Keep one-off screenshots, branded examples, client media, project-specific text, and render intermediates with the external project.

See `tools/agent-edit/MENTION_OVERLAYS.md` for the commands and data format.

Use `contextual-visual-design-local` to invent a new image from the meaning of a mention before adding its timing rule.
