# 02 – Generating Chibi Assets in Scenario

This guide sets up **Scenario** (<https://app.scenario.com>) as the art generation engine for the project. Scenario produces the finished chibi artwork; GIMP is used only afterwards, to split characters into Spine-ready parts ([guide 04](04-splitting-characters-in-gimp.md)).

The full prompt library (characters, props, maps, UI, FX) is in [guide 03](03-scenario-prompt-library.md). This guide covers the platform workflow those prompts run through.

---

## Why Scenario for this pipeline

- **Style-locked generation.** Scenario's core feature is training a custom model on your own reference images, so every generation comes out in *your* chibi style instead of generic AI output.
- **Game-asset tooling built in:** background removal, upscaling, inpainting/canvas fixes, pose control, seamless-tile generation — the whole prep chain before GIMP happens in one place.
- **Iteration speed:** a character concept that took an afternoon to paint takes minutes to generate, and you spend your time on selection and cleanup instead of line work.

What Scenario **cannot** do reliably: output a character pre-separated into head/torso/limb layers. That's why GIMP stays in the pipeline — generation here, surgery there.

## Step 1 — Workspace and project setup

1. Create an account at <https://app.scenario.com> and create a workspace/project for the game (e.g., `chibi-rpg`).
2. Agree on an asset folder convention in this repo before generating anything:

```
art/
├─ raw/                  ← downloads straight from Scenario, untouched
│  ├─ characters/
│  ├─ props/
│  ├─ maps/
│  └─ ui/
├─ gimp/                 ← .xcf split files (characters only)
└─ export/               ← per-part PNGs for Spine (guide 05)
```

3. Inside Scenario, mirror the same structure with collections/folders so the library stays searchable as it grows.

## Step 2 — Build the style model

This is the single highest-leverage step. Do it before generating any production asset.

### 2a. Assemble a training set

- Target **15–40 images** in the exact style you want — consistent line weight, shading, and proportions. Our style targets are documented in [01 – Art Style Guide](01-art-style-guide.md) and shown in [Chibi-game-art.jpg](reference-images/Chibi-game-art.jpg).
- Individual character images work better than a packed sprite sheet. If your references are sheets, crop them into single characters first (GIMP: rectangle-select each character, **Image ▸ Crop to Selection**, export, undo, repeat).
- Variety helps the model generalize: different outfits, headgear, and colors — but *identical* style rules across all of them.

> **Licensing warning — read before training.** Only train on images you have the rights to use for this purpose: your own art, commissioned art, or purchased packs whose license permits derivative/AI-training use. Reference packs you downloaded for "inspiration" usually do **not** grant this. If in doubt, commission or hand-make a small style set (even 15 images) — the model only needs to learn the *style*, and this keeps the project clean.

### 2b. Train

1. In Scenario: **Models ▸ New Model / Train model**.
2. Upload the training set. Choose **style** training (you're teaching a look, not a specific character's identity).
3. Accept the auto-captions but skim them — fix any caption that misdescribes an image, and make sure the word you'll use as the trigger (e.g., `chibi`) appears consistently.
4. Name it clearly (`chibi-heroes-v1`) and train. Training takes minutes to tens of minutes depending on tier.
5. Test with a throwaway prompt (e.g., the hero prompt from guide 03). Judge against the style-guide checklist: head ≈ 50% of height, thick dark-brown outlines, one-tone cel shading, muted palette.
6. Iterate: if outputs drift (thin lines, realistic proportions, soft shading), the training set is inconsistent — remove the outliers and retrain as `-v2`. Expect 2–3 rounds to nail it.

**No time to train yet?** Scenario's public model library has curated chibi/cute-character style models — usable to prototype, but a custom model is what makes 50 assets look like one game. Budget the training session early.

### 2c. Version discipline

- **Never delete a model version that shipped assets.** New model = new version name. If `v3` changes the style, assets made with `v1` won't match — regenerate or stay on the old version per asset family.
- Record in this repo which model version each asset family used (a one-line note in `art/raw/<family>/model.txt` is enough).

## Step 3 — Generation settings that matter

For every generation job:

| Setting | Value | Why |
|---|---|---|
| Model | your custom style model | The whole point |
| Resolution | **1024×1024** minimum for characters/props | Enough pixel budget for the GIMP split; upscale later for hero assets |
| Number of images | 4–8 per prompt | Generation is cheap; selection is the real skill |
| Seed | random while exploring, **locked** once you like a result | A locked seed + small prompt edits = controlled variations |
| Guidance / prompt adherence | mid-range default first | Raise it if outputs ignore the prompt; lower if they look overcooked/rigid |

Prompt structure convention used throughout guide 03:

```
[SUBJECT] , [STYLE BLOCK] , [VIEW/CAMERA] , [BACKGROUND]
```

The style block and negative/avoid terms are defined once at the top of guide 03 and reused verbatim on every asset — that consistency matters as much as the trained model. (If the model you use supports negative prompts, use the negative block; newer models that don't take negatives accept the same terms phrased as "avoid …" in the prompt.)

## Step 4 — Characters: generate for rigging, not for beauty

A character that will be rigged in Spine has **hard pose requirements**. Bake these into every character prompt (guide 03 does):

1. **Full body, front or very slight 3/4 view** — the view your game uses. Pick one and never mix per character.
2. **Relaxed A-pose:** arms angled away from the torso, daylight between arm and body, legs slightly apart, both hands visible and empty. Overlapping limbs are miserable to split in GIMP.
3. **Single character, centered, nothing cropped**, feet fully in frame.
4. **Plain flat background** (solid light gray reads best for judging edges) — never a scene.
5. **No baked ground shadow** — request it, and inpaint it out if it sneaks in.

**Pose control:** if the model keeps improvising poses, use Scenario's image-reference / pose-control features: feed a simple A-pose skeleton or a previously approved character as a structural reference with moderate influence, and the prompt controls the design while the reference controls the pose. Once one character comes out in a good A-pose, **reuse that image as the pose reference for every subsequent character** — this also standardizes proportions across the cast.

**Selection pass:** from each batch, judge candidates against the [style guide checklist](01-art-style-guide.md) plus the rigging rules above. It's normal to generate 20–30 images to get 2–3 keepers. Never settle for "close enough" on pose — one minute of regeneration saves an hour of GIMP surgery.

## Step 5 — In-Scenario cleanup (before GIMP)

Do all of this inside Scenario while the asset is still one image:

1. **Inpaint fixes** (canvas/edit mode): mask the flawed region — a mangled hand, a stray extra strap, a baked shadow — and regenerate just that area with a short local prompt ("simple rounded mitten fist, thick dark outline"). Far faster than repainting in GIMP.
2. **Remove background:** one-click background removal. Inspect the alpha edge at 200% zoom — the outline should stay crisp; halos get cleaned in GIMP if minor, but a chewed-up outline means redo the removal or regenerate.
3. **Upscale to 2048×2048** for characters and hero props (anything that gets split, meshed, or shown large). Small props and icons can stay at 1024.
4. **Download PNG** (with transparency) into the matching `art/raw/...` folder using the naming convention:

```
hero-a-pose.png          goblin-a-pose.png        prop-barrel-01.png
hero-attack-ref.png      tile-stone-floor-01.png  ui-panel-cream.png
```

Lowercase, hyphens, numbered variants — these names flow into GIMP layers, Spine attachments, and Godot resources, so fix them at the source.

## Step 6 — Consistency habits for a growing library

- **One style block, everywhere.** Copy it from guide 03; don't freestyle it per asset.
- **Batch by family:** generate all dungeon props in one session with the same model version and settings — same-day batches match better than assets generated weeks apart.
- **Keep a prompt log.** Scenario stores generation parameters per image; still, copy the exact prompt + seed of every *approved* asset into `art/raw/<family>/prompts.md`. Regenerating a matching variant six months later depends on it.
- **Approved-asset board:** keep a Scenario collection (or a contact sheet image) of every approved asset. Before approving anything new, eyeball it against the board — style drift creeps in one asset at a time.

---

Character approved, background removed, upscaled, downloaded? Continue to [04 – Splitting Characters in GIMP](04-splitting-characters-in-gimp.md). For everything else (props, maps, UI), the asset usually goes straight from Scenario download to Godot import — see the per-category notes in [guide 03](03-scenario-prompt-library.md).
