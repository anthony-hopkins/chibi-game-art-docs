# Game Art Pipeline Documentation

Step-by-step guides for producing chibi-style characters and 2.5D assets for this project using **GIMP → Spine → Godot**.

## Reference material

| Reference | Purpose |
|---|---|
| [Chibi-game-art.jpg](reference-images/Chibi-game-art.jpg) | Target character art style (proportions, outlines, shading, palette) |
| [2.5D-env-example.png](reference-images/2.5D-env-example.png) | Target environment look — low-poly 3D world with 2D characters placed in it |

## Tool versions these guides are written for

| Tool | Version | Notes |
|---|---|---|
| GIMP | 3.0.x | Major UI/API changes vs. 2.10 — menu paths in these guides are GIMP 3 paths |
| Spine | 4.2 (Professional or Essential) | Meshes, weights, and IK require Spine **Professional**; the guides flag which steps are Pro-only |
| Godot | 4.4+ | Using the official `spine-godot` runtime matched to your Spine editor version |

## The guides, in order

1. **[01 – Art Style Guide](01-art-style-guide.md)**
   The rules that make an asset look like the references: proportions, line weight, palette, shading. Read this before drawing anything.

2. **[02 – Creating a Chibi Character in GIMP](02-creating-a-chibi-character-in-gimp.md)**
   Canvas setup, the Spine-friendly layer structure (head, torso, arms, legs, hands, feet on one canvas), and drawing each part with correct overlap for animation.

3. **[03 – Exporting from GIMP for Spine](03-exporting-from-gimp-for-spine.md)**
   Layer naming conventions, per-layer PNG export (automated and manual methods), and how to keep everything aligned for Spine.

4. **[04 – Rigging the Character in Spine](04-rigging-in-spine.md)**
   Importing the exported images, building the skeleton, slots and draw order, and (optional) meshes and weights.

5. **[05 – Animating in Spine](05-animating-in-spine.md)**
   Creating idle, walk, and attack animations: keyframes, curves, looping, and events.

6. **[06 – Getting Spine Characters into Godot](06-spine-to-godot.md)**
   Exporting skeleton data and texture atlases from Spine, setting up the spine-godot runtime, playing animations from GDScript, and placing 2D characters in a 2.5D scene like the environment reference.

## Pipeline at a glance

```
GIMP (draw parts on separate layers, one canvas)
  └─ export one full-canvas PNG per layer
       └─ Spine (import images → bones → slots → animate)
            └─ export .json/.skel + .atlas + packed PNG
                 └─ Godot (spine-godot runtime → SpineSprite in scene)
```

## Golden rules (apply to every asset)

- **One body part = one layer.** Never merge head/torso/limbs before export.
- **Draw the hidden parts.** Where an arm tucks behind the torso, the arm layer must continue under the torso so nothing tears apart when it rotates in Spine.
- **Name layers exactly as they should appear in Spine** (`head`, `torso`, `arm-front-upper`, …). The name travels through the whole pipeline.
- **Work big, ship small.** Paint at 2–4× the final in-game size; Spine's texture packer and Godot handle downscaling cleanly.
- **No baked drop shadows or ground contact** in the character art — shadows are done in-engine (see guide 06).
