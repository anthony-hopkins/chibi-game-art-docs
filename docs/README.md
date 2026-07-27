# Game Art Pipeline Documentation

Step-by-step guides for producing chibi-style characters and 2.5D assets for this project using **Scenario → GIMP → Spine → Godot**.

**Scenario generates all artwork** (characters, props, map assets, UI, FX) in a style-locked custom model. **GIMP's only job** is splitting generated characters into body-part layers for animation. **Spine** rigs and animates them, and **Godot** runs them in-game.

## Reference material

| Reference | Purpose |
|---|---|
| [Chibi-game-art.jpg](reference-images/Chibi-game-art.jpg) | Target character art style (proportions, outlines, shading, palette) — also the style target for Scenario model training |
| [2.5D-env-example.png](reference-images/2.5D-env-example.png) | Target environment look — low-poly 3D world with 2D characters placed in it |

## Tool versions these guides are written for

| Tool | Version | Role |
|---|---|---|
| Scenario | web app (<https://app.scenario.com>) | Generates all art via a custom-trained chibi style model |
| GIMP | 3.0.x | Splits generated characters into Spine-ready part layers; reconstructs hidden overlaps |
| Spine | 4.2 (Professional or Essential) | Rigging + animation. Meshes/weights/IK need **Professional**; guides flag Pro-only steps |
| Godot | 4.4+ | Engine, using the official `spine-godot` runtime matched to your Spine editor version |

## The guides, in order

1. **[01 – Art Style Guide](01-art-style-guide.md)**
   The rules that make an asset look like the references: proportions, line weight, palette, shading. Doubles as acceptance criteria for generated art and as the vocabulary behind the prompt library.

2. **[02 – Generating Chibi Assets in Scenario](02-generating-assets-in-scenario.md)**
   Training a custom style model on your references, generation settings, rig-friendly character requirements (A-pose, plain background), in-Scenario cleanup (inpainting, background removal, upscaling), and consistency habits.

3. **[03 – Scenario Prompt Library](03-scenario-prompt-library.md)**
   Copy-paste prompt recipes for everything: heroes, enemies, NPCs, skins, weapons, props, seamless map tiles, walls and buildings, backdrops, UI panels, icons, and FX sprites — plus a vertical-slice coverage checklist.

4. **[04 – Splitting Characters in GIMP](04-splitting-characters-in-gimp.md)**
   Cutting a generated character into head, torso, arms, legs, hands, and feet layers on one canvas — and painting back the hidden overlap at every joint so Spine can rotate parts without tears.

5. **[05 – Exporting from GIMP for Spine](05-exporting-from-gimp-for-spine.md)**
   Layer naming conventions, per-layer full-canvas PNG export (Batcher or manual), and how alignment is preserved for Spine.

6. **[06 – Rigging the Character in Spine](06-rigging-in-spine.md)**
   Importing the exported images, building the skeleton, slots and draw order, and (optional) meshes and weights.

7. **[07 – Animating in Spine](07-animating-in-spine.md)**
   Creating idle, walk, and attack animations: keyframes, curves, looping, and events.

8. **[08 – Getting Spine Characters into Godot](08-spine-to-godot.md)**
   Exporting skeleton data and texture atlases from Spine, setting up the spine-godot runtime, playing animations from GDScript, and assembling 2.5D scenes from generated tiles and props.

## Pipeline at a glance

```
Scenario (custom style model → generate, inpaint, remove bg, upscale)
  ├─ props / tiles / UI / FX ──────────────────────────┐
  └─ characters (A-pose PNG)                           │
       └─ GIMP (split into part layers, rebuild        │
          hidden overlaps)                             │
            └─ export one full-canvas PNG per layer    │
                 └─ Spine (bones → slots → animate)    │
                      └─ .json/.skel + atlas           │
                           └─ Godot (SpineSprite) ◄────┘
                                    (Sprite2D / TileMapLayer)
```

Only characters take the GIMP → Spine detour. Props, tiles, UI, and FX go straight from Scenario into Godot.

## Golden rules (apply to every asset)

- **One style model, one style block.** Every generation uses the trained model and the shared prompt blocks from guide 03 — no freestyling the style description per asset.
- **Regenerate, don't repaint.** If a generation misses the style guide or the A-pose rules, fix it in Scenario (new seed, inpaint) — GIMP time is reserved for splitting, not correcting.
- **Characters generate in a rig-friendly A-pose** — arms clear of the torso, plain background, empty hands, no baked ground shadow.
- **One body part = one layer** in the GIMP split, and **the hidden overlap gets painted back at every joint** — this is what makes the character animatable.
- **Name things once, at the source.** Scenario download → GIMP layer → exported PNG → Spine attachment → Godot resource all share the same lowercase-hyphen name.
- **Log every approved prompt + seed** (`art/raw/<family>/prompts.md`) so matching assets can be regenerated months later.
