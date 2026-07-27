# Asset-Pack → Godot Animation Pipeline

Step-by-step guides for building animated 2D characters in **Godot 4.4+** using purchased or downloaded **asset packs whose characters ship pre-split into components** — no external animation tools (Spine, Spriter, DragonBones) and no art-generation steps. Everything after the pack download happens natively inside Godot.

The reference pack for every guide is [`example-asset-pack/`](../example-asset-pack/) at the repo root — a chibi "Villager" character that ships with:

- **Split body-part PNGs** (`Body.png`, `Head.png`, `Left Arm.png`, …) on a shared, pre-aligned canvas — used for **cutout (skeletal-style) animation** built in Godot.
- **Numbered frame sequences** (`0_Villager_Idle_000.png` … `0_Villager_Walking_023.png`, 17 animations) — used for **frame-by-frame animation**.

Both routes are covered; they can be mixed freely in one project.

## The guides, in order

1. **[01 – Anatomy of a Split-Component Asset Pack](01-asset-pack-anatomy.md)**
   What's inside a pack like this, the file-naming logic, the full animation/frame inventory of the example pack, how to verify a pack before building on it, and licensing hygiene.

2. **[02 – Importing the Asset Pack into Godot](02-importing-into-godot.md)**
   Creating the project, restructuring and renaming the pack files into a Godot-friendly layout (scripts included), import settings for high-resolution hand-drawn art, and keeping non-engine files out of `res://`.

3. **[03 – Frame-by-Frame Animation with AnimatedSprite2D](03-frame-by-frame-animation.md)**
   The fastest path from pack to moving character: building a `SpriteFrames` library from the numbered sequences, per-animation FPS and looping, previewing in-editor, and **running it live** with F6/F5.

4. **[04 – Building a Cutout Rig from the Split Parts](04-cutout-rigging.md)**
   Reassembling the component PNGs into a jointed character: scene hierarchy, rotation pivots at the joints, draw order, and a rest pose — the Godot-native equivalent of rigging.

5. **[05 – Animating the Rig and Running It in Game](05-running-animations-in-game.md)**
   Keyframing idle/walk/attack with `AnimationPlayer`, RESET tracks and looping, optional `AnimationTree` state machine, and a complete playable `CharacterBody2D` demo that switches animations from input — ending with the character running live in the engine.

## Pipeline at a glance

```
asset pack (downloaded .zip)
  ├─ split part PNGs (Body, Head, Arms, …)
  │    └─ Godot: Sprite2D hierarchy + joint pivots   (guide 04)
  │         └─ AnimationPlayer keyframes             (guide 05)
  ├─ numbered frame sequences (Idle_000 … )
  │    └─ Godot: AnimatedSprite2D + SpriteFrames     (guide 03)
  └─ vendor extras (.eps, .scml, .unitypackage, license)
       └─ stay OUTSIDE res:// (source archive only)  (guide 02)

both routes → CharacterBody2D + input-driven playback → F5, live in game
```

## Golden rules (apply to every pack)

- **Verify the pack before you build on it.** Open each part PNG and confirm it contains *only* that part; open a few frames and confirm the pose actually changes (guide 01 has a checklist). ⚠️ Note: in the local copy of `example-asset-pack/`, the part PNGs currently contain full-character preview renders rather than isolated parts — the frame sequences are genuine. The cutout guides (04–05) are written for a correctly-split pack; re-download or re-export the parts before following them against this pack.
- **Only PNGs enter the Godot project.** Vendor source files (`.eps`, `.scml`, `.unitypackage`, readme/license) stay in an archive folder outside `res://` — they are useless to Godot and slow down import scans.
- **Rename once, at import time.** `0_Villager_Idle Blinking_004.png` becomes `frames/idle-blinking/004.png` before Godot ever sees it. Lowercase, hyphens, no spaces — the animation name in Godot matches the folder name exactly.
- **Numbering gaps are normal.** Vendors drop duplicate frames (`Running` has no `002`); Godot adds frames in file order and never needs contiguous numbers.
- **One-shot vs loop is a design decision, not a default.** Locomotion loops (idle, walk, run, jump-loop); actions and reactions don't (attacks, hurt, dying, jump-start). Set it per animation the moment you create it.
- **Keep the license with the art.** Copy the pack's license file into the archive folder and record where/when the pack was obtained.
