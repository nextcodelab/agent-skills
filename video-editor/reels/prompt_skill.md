# Reusable Local Video Skill Prompt: Create 1-minute vertical Shorts by dividing the total raw video duration, or select only the best highlights, depending on the client's instructions (always wait for client approval).

Use the project-local `opusclip-local` skill and local tools only. Do not call OpusClip, HeyGen, cloud rendering, hosted MCP, external transcription, or any hosted video/media API. Do not read, expose, or use vendor API keys.

## Source

`C:\Users\Robel\Desktop\video-editors\raw\YTSave.to_YouTube_Media_i6hr3EXC7hU_We-Challenged-NATALIA-For-Her-SURPRISE-GIFT-Birthday_001_1080p.mp4`

## Deliverables

Create distinct short-form MP4 clips based on the client's instructions: either divide the total raw video duration into approximately 1-minute clips or select only the best highlights. Dynamically determine the number of clips and generate meaningful titles. Record each clip's source in/out timestamps, title, and actual filename in `shorts_manifest.csv`. Save the MP4 files under `C:\Users\Robel\Desktop\video-editors\outputs\{title}\{files}`, where `{title}` is the dynamically generated, agent-renamable project folder name and `{files}` represents the actual exported MP4 filenames. Always present the edit plan and wait for client approval before rendering.

## Picture and motion

- Export full-height 9:16 vertical video at 1080x1920, 30 fps, H.264/AAC.

- Fill the vertical frame with a clean 9:16 crop around the active person/action. Crop out the source video’s burned-in subtitle strip where present so it does not collide with the new captions. Never stretch the source and never use blurred sidebars, blurred backgrounds, or generated padding.

- Use a subtle, smooth zoom-in/zoom-out camera move and small horizontal drift. Keep the important face/action in the crop and avoid abrupt movement.

- Leave the original source media untouched.

## Captions and effects

- Use the existing local transcript. Keep caption wording faithful to the audio and place captions in a readable lower safe area.

- Add a short animated opening hook and per-caption pop/fade-in with word-by-word highlight animation. Maintain a strong outline and contrast; keep text clear of faces and platform UI.

- Preserve the original audio and avoid abrupt cuts or clipped words.

## Local workflow

1. Inspect the source and current local transcript/edit plan.

2. Render with FFmpeg and local subtitle files; do not use hosted rendering or generation services.

3. Review all 21 outputs for playback, duration, 9:16 dimensions, captions, and crop quality; adjust and rerender any failures.

4. Save this prompt/skill with the outputs so the workflow is reusable.

# Advanced Smart Video Editing — Captions, Stickers, Memes, Contextual Visuals & Humor

## Objective

Upgrade the existing local video-editing workflow with intelligent, context-aware visual effects inspired by professional Shorts, Reels, TikTok, OpusClip-style editing, and Hyperframe-style motion graphics.

Make the resulting videos engaging, entertaining, visually polished, and family-friendly without overwhelming the original content.

**All processing must use local tools, installed PC skills, available AI models, and FFmpeg-compatible rendering. No hosted media APIs or cloud rendering.**

## 1. Automatic Spoken-Language Detection

Detect the language actually spoken in each video or speech segment.

Supported language behavior:

- Locally spoken language → Captions in that same language.

- English speech → English captions.

- Mixed-language speech → Preserve the actual words in each spoken language.

- Other languages → Transcribe in the original spoken language when supported by the installed local ASR model.

- Multiple speakers → Preserve each speaker's spoken language.

- Language switching → Detect language changes where reliable.

### Important caption rules

- Never automatically translate unless the client requests translation.

- Never replace original-language speech with English captions unless translation is requested.

- Preserve natural expressions and slang in the spoken language.

- Keep transcript wording faithful to the audio.

- Apply proper punctuation without changing meaning.

- Do not invent missing words.

- If transcription confidence is low, flag the segment for review.

- Detect language using audio, not filename or video title.

Example:

Spoken audio:

"Wow! That was really impressive!"

Displayed captions:

**WOW! THAT WAS REALLY IMPRESSIVE!**

If the speaker says:

"Guys, I really did not expect that!"

Display the original spoken wording, including any language switching, rather than translating it.

Use verified local multilingual ASR and word-alignment tools when available.

## 2. Dynamic Pop-Up Captions

Create animated, synchronized captions that react to speech.

### Caption effects

- Word-by-word highlighting.

- Pop-in and pop-out.

- Subtle bounce.

- Scale-up emphasis.

- Smooth fade.

- Keyword color highlighting.

- Short kinetic text movement.

- Question-mark and exclamation effects.

- Occasional comic-style text bubbles.

### Example

Spoken:

"Wow, that gift is huge!"

Visual sequence:

```text

WOW!          ← Quick pop

THAT GIFT     ← Slight scale-up

IS HUGE! 🎁   ← Gift sticker appears

```

Use word-level timestamps when available.

Avoid constant bouncing, flashing, or distracting animation.

### Caption positioning

- Keep captions in the mobile-safe area.

- Avoid covering faces.

- Avoid covering important objects.

- Avoid TikTok, YouTube Shorts, and Reels interface regions.

- Keep text readable on small phone screens.

- Use consistent fonts, outlines, and shadows.

## 3. Intelligent Context-Aware Stickers

Analyze the spoken dialogue and visible scene to determine when a sticker would improve the video.

Do not insert stickers randomly.

Replace your existing **Intelligent Context-Aware Stickers — Examples** section with this dynamic, language-independent version. It supports English, Filipino, and any other spoken language supported by the local AI models.

### Examples — Dynamic Multilingual Context-Aware Stickers

Automatically detect the meaning of spoken dialogue in its original language and select relevant stickers, emojis, animations, or visual previews.

**Do not hardcode English, Filipino, or any specific language.** The following are examples only. The system must dynamically understand equivalent expressions across supported languages.

| Spoken content or event (any language)  | Suggested effect                         |

| --------------------------------------- | ---------------------------------------- |

| Doctor, medical appointment, healthcare | Doctor illustration or medical icon      |

| Birthday, celebration                   | Cake, balloons, or confetti              |

| Surprise, unexpected event              | Surprised emoji or animated reaction     |

| Happiness, excitement                   | Smiling emoji or celebration             |

| Expensive, money, payment               | Money animation or shocked reaction      |

| Winning, achievement, success           | Trophy or celebration                    |

| Tiredness, exhaustion                   | Tired emoji or humorous reaction         |

| Delicious food, eating                  | Food sticker or happy reaction           |

| Wait, pause, hesitation                 | Comedic pause or question marks          |

| Disbelief, unexpected news              | Surprised reaction or subtle zoom        |

| Animals, pets                           | Relevant animal sticker                  |

| Vehicles, transportation                | Car, airplane, or transportation icon    |

| School, education                       | Teacher, book, or classroom illustration |

| Travel, vacation                        | Travel-themed visual                     |

| Love, friendship, family                | Heart or appropriate emotional sticker   |

### Universal Language-Aware Behavior

1. Detect the actual spoken language automatically.

2. Analyze the complete sentence and surrounding context, not just individual keywords.

3. Identify language-independent semantic concepts such as `doctor`, `birthday`, `surprise`, `money`, or `celebration`.

4. Match equivalent meanings across any spoken language supported by the installed local models.

5. Support mixed-language conversations and code-switching.

6. Select relevant stickers based on meaning, emotion, and visible events.

7. Synchronize sticker appearances with the corresponding speech timestamps.

8. Use culturally appropriate, family-friendly visuals.

9. Avoid inserting irrelevant or repetitive stickers.

10. If the meaning is uncertain, omit the effect rather than guessing.

### Example — Same Meaning, Different Languages

```

Original speech (any supported language): "I went to the doctor."

Detected semantic concept: doctor

Suggested effect:

Small doctor illustration or medical icon

Duration: 1–3 seconds

Animation: Smooth pop-in and fade-out

```

### Context-Aware Humor

The agent may add light humor, playful emojis, meme-style reactions, or subtle punch-in effects when appropriate.

Humor must follow the original meaning and cultural context. Never assume that an expression is funny based solely on its literal translation.

### Final Rules

- **Spoken language:** Automatically detected.

- **Caption language:** Original spoken language by default.

- **Sticker selection:** Based on semantic meaning, not hardcoded keywords.

- **Visual effects:** Context-aware and dynamically timed.

- **Humor:** Natural, culturally appropriate, and child-friendly.

- **Language support:** Determined by installed local AI model capabilities.

- **Fallback:** Skip uncertain effects rather than displaying misleading visuals.

Stickers should always be relevant to the meaning, emotion, and timing of the moment, regardless of the language spoken.

**Key improvement:** Your agents should recognize *concepts*, not just words. For example, equivalent expressions for a medical professional can trigger the same medical sticker without hardcoded language-specific rules.

## 4. Smart Visual Preview / Picture-in-Picture

When someone mentions a recognizable object, occupation, animal, place, or concept, the agent may display a small contextual visual for a few seconds.

### Example — Doctor

Speaker says:

"We went to the doctor yesterday."

Editing behavior:

1. Detect the word "doctor."

2. Understand the surrounding sentence.

3. Select a suitable local doctor illustration or medical icon.

4. Display it for approximately 1–3 seconds.

5. Apply a subtle pop-in animation.

6. Position it away from faces and captions.

7. Remove it smoothly.

The preview must not imply that the illustration is the actual doctor being discussed.

### Other examples

- Teacher → Classroom or teacher illustration.

- Car → Car icon or relevant visual.

- Airplane → Small airplane animation.

- Dog → Dog sticker.

- School → School illustration.

- Money → Animated coins.

- Food → Relevant food illustration.

- Vacation → Travel-themed icon.

### Context accuracy

Do not treat every keyword as a literal visual instruction.

Example:

"He really looks like a doctor."

This may be a metaphor, so a doctor preview might be inappropriate.

Analyze sentence meaning before adding visual effects.

Use verified, locally available assets. Do not invent real photographs or imply that generic visuals depict actual people or events.

## 5. Family-Friendly Humor and Memes

Add light, natural humor when it fits the scene.

### Allowed effects

- Laughing emoji reactions.

- Funny but respectful stickers.

- Comic-style text.

- Short comedic zoom.

- Gentle reaction animations.

- Playful sound effects from approved local assets.

- Small meme-style overlays.

- Surprised reaction bubbles.

- Humorous pauses.

- Lighthearted celebration effects.

### Example — Funny reaction

Speaker:

"I thought it was free, but it actually costs money!"

Possible editing:

```text

I THOUGHT IT WAS FREE! 😁

[Short comedic pause]

IT COSTS MONEY! 😭💸

```

Add a subtle punch-in at the reveal.

### Example — Unexpected surprise

Speaker:

"Wait! Is that really true?"

Effects:

- Quick reaction zoom.

- Surprised emoji.

- Small animated question marks.

- Short caption emphasis.

### Humor restrictions

- Keep humor suitable for children and families.

- No offensive or discriminatory jokes.

- No sexual or adult humor.

- No frightening or disturbing meme inserts.

- No excessive flashing.

- Do not mock disabilities, medical conditions, or personal appearance.

- Do not turn serious or emotional moments into jokes.

- Do not fabricate reactions or misrepresent the speaker.

Humor must support the original scene, not replace it.

## 6. Smart Emotional Editing

Classify the emotional tone of each segment using the available transcript, audio, and visual evidence.

Possible categories:

- Happy.

- Funny.

- Surprised.

- Excited.

- Curious.

- Serious.

- Emotional.

- Educational.

- Calm.

Choose effects accordingly.

| Emotion | Editing treatment |

|---|---|

| Happy | Subtle celebration stickers |

| Funny | Light comedic zoom and reaction |

| Surprised | Quick pop caption |

| Excited | Energetic text emphasis |

| Serious | Minimal effects |

| Emotional | Gentle fades, fewer overlays |

| Educational | Contextual illustrations |

| Calm | Clean captions and subtle motion |

Never infer a person's private emotional state as fact. Treat classifications as editing suggestions.

## 7. Dynamic Sticker and Meme Asset Library

Discover reusable assets from authorized local project directories.

Suggested structure:

```text

video-editors/

├── assets/

│   ├── stickers/

│   │   ├── reactions/

│   │   ├── celebrations/

│   │   ├── professions/

│   │   ├── animals/

│   │   ├── objects/

│   │   └── educational/

│   ├── memes/

│   │   └── family-friendly/

│   ├── sound-effects/

│   ├── overlays/

│   └── fonts/

```

These directories are optional and may be created after client approval.

Supported asset formats may include:

- PNG.

- WebP.

- SVG.

- GIF.

- Transparent WebM.

- MP4 overlays.

- WAV and MP3 sound effects.

Use compatible local renderers to process each asset.

### Asset selection

Each asset should have metadata describing:

- Name.

- Category.

- Keywords.

- Language-independent concepts.

- Suitable emotions.

- File path.

- License or usage rights.

- Animation duration.

- Recommended display size.

Do not use copyrighted meme clips, movie footage, music, or third-party images without appropriate rights.

If no suitable local asset exists, omit the effect or propose a locally supported asset-creation workflow.

## 8. Smart Effect Timing

Use speech timestamps, scene boundaries, and visual tracking to synchronize effects.

Suggested defaults:

| Effect | Typical duration |

|---|---|

| Small emoji reaction | 0.5–1.5 seconds |

| Contextual object preview | 1–3 seconds |

| Caption pop | 0.15–0.35 seconds |

| Comedic punch-in | 0.3–0.8 seconds |

| Celebration overlay | 1–2 seconds |

| Informational label | 2–4 seconds |

These are starting points, not mandatory durations.

Adjust based on speech speed, clip pacing, and readability.

Avoid placing too many effects simultaneously.

## 9. Effect Intensity Profiles

Support configurable editing intensity.

### Minimal

- Accurate captions.

- Occasional keyword emphasis.

- Minimal stickers.

- Smooth crop movement.

### Balanced — Default

- Animated captions.

- Relevant stickers.

- Occasional contextual previews.

- Light humor.

- Subtle zoom effects.

### Energetic

- More frequent kinetic captions.

- More reaction stickers.

- Dynamic but controlled zoom.

- Stronger visual emphasis.

- Playful, family-friendly meme effects.

Even in Energetic mode, avoid constant visual clutter.

Allow the client to select or override the intensity.

## 10. Local Skill Integration

Use existing verified local implementations whenever available.

Possible roles:

**OpusClip-local**

- Highlight detection.

- Clip selection.

- Speech analysis.

- Hook identification.

- Intelligent segmentation.

**Hyperframe-local**

- Animated captions.

- Visual effects.

- Motion graphics.

- Dynamic reframing.

- Sticker animations.

- Picture-in-picture overlays.

**Other local tools**

- FFmpeg: Composition and rendering.

- ASS/libass: Caption styling and timing.

- OpenCV: Object and face tracking.

- Local ASR: Language detection and transcription.

- Local alignment: Word-level timing.

- Remotion, MoviePy, or equivalent: Programmatic animations when installed.

These are intended responsibilities, not guarantees about existing implementations. Inspect each skill before using it.

## 11. Dynamic Effects Manifest

Extend `edit_plan.json` with optional effect instructions.

Example:

```json

{

  "clip_id": "001",

  "detected_language": "auto",

  "caption_language": "original",

  "effect_profile": "balanced",

  "effects": [

    {

      "type": "contextual_sticker",

      "keyword": "doctor",

      "start_seconds": 12.4,

      "duration_seconds": 2.0,

      "asset_category": "professions",

      "asset_name": "doctor",

      "position": "top_right",

      "animation": "pop_in"

    },

    {

      "type": "reaction_emoji",

      "keyword": "surprise",

      "start_seconds": 18.2,

      "duration_seconds": 1.2,

      "emoji": "😲",

      "animation": "bounce"

    }

  ]

}

```

All timestamps above are illustrative. Actual values must come from the source media.

Every effect must have a valid local implementation and required assets before rendering.

## 12. Agent Workflow

For every source video:

1. Discover available local editing skills and tools.

2. Inspect the video and detect spoken languages.

3. Generate or load the faithful transcript.

4. Identify important words, objects, events, and emotional moments.

5. Select appropriate stickers and contextual previews.

6. Identify suitable family-friendly humor opportunities.

7. Choose caption animation styles.

8. Verify local assets and effect implementations.

9. Add timed effects to the edit plan.

10. Show the client the proposed effects and editing intensity.

11. **Wait for explicit client approval before rendering.**

12. Render with verified local tools.

13. Review captions, visual timing, asset placement, and audio.

14. Remove or adjust distracting or inaccurate effects.

15. Save reusable configurations for future videos.

## 13. Quality and Safety Rules

- Match caption language to actual spoken language.

- Preserve the original spoken language and mixed-language speech naturally.

- Never invent dialogue.

- Never add misleading contextual previews.

- Never fabricate real people or events.

- Avoid distracting effects.

- Keep humor child-friendly.

- Avoid copyrighted or unlicensed meme assets.

- Preserve original audio and intended meaning.

- Use locally verified capabilities only.

- Never modify the original video.

- Never render before client approval.

## Final Editing Principle

Make each Short feel professionally edited by a creative human editor.

Captions should follow the speaker.

Stickers should follow the context.

Humor should follow the moment.

Visual previews should help viewers understand the story.

Effects should enhance the video without distracting from its meaning.

**The goal is not to add as many effects as possible. The goal is to make every effect feel intentional, entertaining, and natural.**
