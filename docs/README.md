# Asset-Pack → Godot Animation Pipeline

Step-by-step guides for building animated 2D characters in **Godot 4.4+** using purchased or downloaded **asset packs whose characters ship pre-split into components** — no external animation tools (Spine, Spriter, DragonBones) and no art-generation steps. Everything after the pack download happens natively inside Godot.

The reference pack for every guide is [`example-asset-pack/Villager_1/`](../example-asset-pack/Villager_1/) — a CraftPix chibi "Villager" character that ships with:

- **Individually cropped vector-part PNGs** (`PNG/Vector Parts/` — body, head, faces, arms, hands, legs, sword, slash effect) — used for **cutout (skeletal-style) animation** built in Godot.
- **Numbered frame sequences** (`PNG/PNG Sequences/<Animation>/`, 17 animations, 900 × 900 frames) — used for **frame-by-frame animation**.
- **Vector sources and a Spriter project** (`AI/`, `EPS/`, `Animations.scml`) — never imported, but the `.scml` doubles as the authoritative reference for part hierarchy, draw order, and the vendor's animation timing.

Both animation routes are covered; they can be mixed freely in one project.

## The guides, in order

1. **[01 – Anatomy of a Split-Component Asset Pack](01-asset-pack-anatomy.md)**
   What's inside the pack folder-by-folder, the part and animation inventories, what the Spriter file is good for, how to verify a pack before building on it, and licensing hygiene.

2. **[02 – Importing the Asset Pack into Godot](02-importing-into-godot.md)**
   Creating the project, restructuring and renaming the pack files into a Godot-friendly layout (scripts included), import settings for high-resolution hand-drawn art, and keeping non-engine files out of `res://`.

3. **[03 – Frame-by-Frame Animation with AnimatedSprite2D](03-frame-by-frame-animation.md)**
   The fastest path from pack to moving character: building a `SpriteFrames` library from the numbered sequences, per-animation FPS and looping, previewing in-editor, and **running it live** with F6/F5.

4. **[04 – Building a Cutout Rig from the Vector Parts](04-cutout-rigging.md)**
   Assembling the cropped component PNGs into a jointed character: scene hierarchy, rotation pivots at the joints, draw order taken straight from the pack's Spriter file, and a rest pose — the Godot-native equivalent of rigging.

5. **[05 – Animating the Rig and Running It in Game](05-running-animations-in-game.md)**
   Keyframing idle/walk/attack with `AnimationPlayer`, RESET tracks and looping, optional `AnimationTree` state machine, and a complete playable `CharacterBody2D` demo that switches animations from input — ending with the character running live in the engine.

## Pipeline at a glance

```
asset pack (downloaded .zip)
  ├─ PNG/Vector Parts/  (cropped part PNGs)
  │    └─ Godot: Sprite2D hierarchy + joint pivots   (guide 04)
  │         └─ AnimationPlayer keyframes             (guide 05)
  ├─ PNG/PNG Sequences/<Animation>/  (numbered frames)
  │    └─ Godot: AnimatedSprite2D + SpriteFrames     (guide 03)
  └─ AI/ EPS/ .scml unitypackage license
       └─ stay OUTSIDE res:// (source archive;       (guide 02)
          .scml consulted for hierarchy & draw order)

both routes → CharacterBody2D + input-driven playback → F5, live in game
```

## Golden rules (apply to every pack)

- **Verify the pack before you build on it.** Open a few part PNGs and confirm each contains *only* its named component; open a few frames and confirm the pose actually changes; check the license (guide 01 has the checklist). Corrupt downloads and preview-image bundles are common enough to make this worth 5 minutes every time.
- **Only PNGs enter the Godot project.** Vendor source files (`.ai`, `.eps`, `.scml`, `.unitypackage`, readme/license) stay in an archive folder outside `res://` — they are useless to the engine and slow down import scans.
- **Rename once, at import time.** `0_Villager_Idle Blinking_004.png` becomes `frames/idle-blinking/004.png` before Godot ever sees it. Lowercase, hyphens, no spaces — the animation name in Godot matches the folder name exactly.
- **The Spriter/DragonBones project file is documentation, not junk.** You won't import it, but it records the vendor's part hierarchy, draw order, and frame timing — consult it whenever assembly or animation questions come up.
- **One-shot vs loop is a design decision, not a default.** Locomotion loops (idle, walk, run, jump-loop); actions and reactions don't (attacks, hurt, dying, jump-start). Set it per animation the moment you create it.
- **Keep the license with the art.** Copy the pack's license file into the archive folder and record where/when the pack was obtained.
