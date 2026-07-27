# 01 – Anatomy of a Split-Component Asset Pack

Before anything touches Godot, understand exactly what the pack gives you. This guide walks the contents of [`example-asset-pack/Villager_1/`](../example-asset-pack/Villager_1/) folder-by-folder; most commercial 2D character packs (CraftPix, GameArt2D, itch.io bundles, …) follow the same shape.

## The pack layout

```
Villager_1/
├── AI/                      Villager.ai — Adobe Illustrator master (all parts, all layers)
├── EPS/                     Villager_<Part>.eps — one vector source per part
├── PNG/
│   ├── Vector Parts/        ← the cutout kit (+ Animations.scml, the Spriter project)
│   └── PNG Sequences/       ← the frame-by-frame kit, one folder per animation
├── TXT/
│   ├── license.txt          → https://craftpix.net/file-licenses/
│   └── readme.txt           font credit ("Moon Get!")
└── Unity Package/           Villager.unitypackage — meaningless to Godot
```

Only `PNG/` matters for the Godot pipeline. Everything else is source/archive material.

## 1. `PNG/Vector Parts/` — the cutout kit

One PNG per component, **each cropped to its own canvas** and rendered from the vector source:

| File | Canvas | Component |
|---|---|---|
| `Body.png` | 320 × 320 | Torso: tunic, belt, boots-to-neck trunk (the rig root) |
| `Head.png` | 480 × 480 | Head + hair, no face — the biggest part; chibi proportions |
| `Face 01.png` – `Face 03.png` | 320 × 240 | Swappable facial expressions |
| `Left Arm.png`, `Right Arm.png` | 128 × 128 | One arm each, drawn at the rest-pose diagonal |
| `Left Hand.png`, `Right Hand.png` | 128 × 128 | Hands (separate so they can hold props) |
| `Left Leg.png`, `Right Leg.png` | 128 × 128 | Legs incl. feet |
| `Sword.png` | 400 × 128 | Weapon prop, drawn horizontally |
| `SlashFX.png` | 496 × 496 | Swing visual effect |

Key properties to notice — they drive the whole rigging approach in guide 04:

- **Parts are individually cropped, not on a shared canvas.** Stacking them at one position does *not* reassemble the character; each part gets placed at its joint during rigging. (Some vendors export full-canvas-aligned parts instead — check, because that changes the assembly workflow.)
- **All parts share one consistent scale** — they were exported together from one Spriter/Illustrator project, so they fit each other 1:1 with no per-part scaling.
- **"Left/Right" is the character's own left/right,** and the art faces right. The character's left side is the *far* side (drawn behind the body). In Godot you mirror the whole rig with a negative `scale.x` rather than ever authoring a left-facing set.

### `Animations.scml` — the rig's documentation

Sitting among the parts is the vendor's **Spriter project** (plain XML, openable in any text editor). You will never import it into Godot, but it is the authoritative answer to three questions guide 04 otherwise answers by eye:

- **Draw order** — its `Base` animation lists parts back-to-front: SlashFX, Sword, Left Hand, Left Arm, Left Leg, Right Leg, Body, Head, Face, Right Hand, Right Arm.
- **Hierarchy** — an 8-bone skeleton with arms/hands and head chained off the body.
- **Timing** — 17 named animations on a 33 ms (30 FPS) timeline, matching the PNG sequences 1:1. If an animation you re-author in guide 05 feels off, compare its keyframe times here.

## 2. `PNG/PNG Sequences/` — the frame-by-frame kit

One folder per animation; files are `0_<Character>_<Animation>_<frame>.png`, every frame a **900 × 900** canvas with the fully-assembled character posed per frame. The pack ships **17 animations, 195 frames**, contiguously numbered from `000`:

| Animation | Frames | Loop? (recommended) |
|---|---|---|
| Idle | 18 | loop |
| Idle Blinking | 18 | loop |
| Walking | 24 | loop |
| Running | 12 | loop |
| Jump Start | 6 | one-shot |
| Jump Loop | 6 | loop (airborne hold) |
| Sliding | 6 | one-shot |
| Kicking | 12 | one-shot |
| Slashing | 12 | one-shot |
| Slashing in The Air | 12 | one-shot |
| Run Slashing | 12 | one-shot |
| Throwing | 12 | one-shot |
| Throwing in The Air | 12 | one-shot |
| Run Throwing | 12 | one-shot |
| Hurt | 12 | one-shot |
| Falling Down | 6 | one-shot |
| Dying | 15 | one-shot |

This pack numbers every sequence contiguously, but don't rely on that in general — vendors sometimes delete near-duplicate frames after export, leaving gaps. Harmless either way: Godot builds animations from an ordered file list, not from the numbers.

## 3. Vendor extras — never imported

| Item | What it is | What to do with it |
|---|---|---|
| `AI/Villager.ai` | Illustrator master file | Archive. The one file to reopen if you want to recolor the character or re-export any part at a different resolution. |
| `EPS/*.eps` | Per-part vector sources (Illustrator/Inkscape-compatible) | Archive. Same purpose, per part. |
| `Unity Package/` | Unity import bundle | Archive or delete. |
| `TXT/readme.txt` | Credit for the font used in the pack's marketing art | Archive. |
| `TXT/license.txt` | Points to the CraftPix file license | **Read it**, archive it with the art. Note it governs redistribution — committing raw pack files to a *public* repo is generally not allowed. |

## Pack verification checklist

Run this on every pack *before* building anything on it. Broken downloads, re-zipped bundles, and marketplace preview images masquerading as assets are all common.

1. **Open 3–4 part PNGs in an image viewer.** Each must show *only* its named component (a lone arm, a bare head) on transparency — **not** the whole character. A full character inside `Left Arm.png` means you have preview renders, not a cutout kit.
2. **Open the first and a middle frame of one animation** (e.g. `Running_000` vs `Running_005`). The pose must clearly differ.
3. **Note whether parts are individually cropped or share one canvas** (open two parts and compare canvas sizes). Both are workable; guide 04 covers the cropped style this pack uses and notes the shortcut the shared-canvas style allows.
4. **Confirm real file types** — a quick paranoia check that nothing is mislabeled (Git Bash / WSL): `file $(find . -type f) | grep -vE "PNG image|XML|ASCII|PDF|gzip"` from the pack root should return nothing.
5. **Read the license** — confirm game use, whether attribution is required, and whether redistribution of the raw files is allowed.

## Next

→ **[02 – Importing the Asset Pack into Godot](02-importing-into-godot.md)**
