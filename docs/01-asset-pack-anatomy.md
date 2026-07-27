# 01 – Anatomy of a Split-Component Asset Pack

Before anything touches Godot, understand exactly what the pack gives you. This guide walks the contents of [`example-asset-pack/`](../example-asset-pack/) file-by-file; almost every commercial 2D character pack (GameArt2D, CraftPix, itch.io packs, …) follows the same shape.

## The three kinds of files

### 1. Split body-part PNGs — the cutout kit

One PNG per component, all on the **same canvas size** (here 900 × 900), each part drawn **in its assembled position** on that canvas:

| File | Component |
|---|---|
| `Body.png` | Torso + hips (the rig root) |
| `Head.png` | Head + hair, no face |
| `Face 01.png`, `Face 02.png`, `Face 03.png` | Swappable facial expressions |
| `Left Arm.png`, `Right Arm.png` | Upper+lower arm |
| `Left Hand.png`, `Right Hand.png` | Hands (separate so they can hold props) |
| `Left Leg.png`, `Right Leg.png` | Legs incl. feet |
| `Sword.png` | Weapon prop |
| `SlashFX.png` | Swing visual effect |

The shared-canvas convention is the whole trick: **stack every part at the same position and the character reassembles itself perfectly.** No measuring, no manual alignment. Guide 04 exploits this to build the rig.

"Left/Right" is from the *character's* point of view, and the art is side-view facing right — in Godot you'll mirror the whole rig with `scale.x = -1` or `flip_h` rather than ever authoring a left-facing set.

### 2. Numbered frame sequences — the frame-by-frame kit

Pattern: `0_<Character>_<Animation>_<frame>.png`, same 900 × 900 canvas, character posed per frame. The example pack ships **17 animations, 216 frames**:

| Animation | Frames | Numbering | Loop? (recommended) |
|---|---|---|---|
| Idle | 18 | 000–017 | loop |
| Idle Blinking | 16 | 000–007, 010–017 | loop |
| Walking | 23 | 000–020, 022–023 | loop |
| Running | 11 | 000–001, 003–011 | loop |
| Jump Start | 5 | 000–003, 005 | one-shot |
| Jump Loop | 6 | 000–005 | loop (airborne hold) |
| Sliding | 6 | 000–005 | one-shot |
| Kicking | 11 | 000–004, 006–011 | one-shot |
| Slashing | 10 | 000–003, 006–011 | one-shot |
| Slashing in The Air | 11 | 000–002, 004–011 | one-shot |
| Run Slashing | 11 | 001–011 | one-shot |
| Throwing | 9 | 001–006, 009–011 | one-shot |
| Throwing in The Air | 12 | 000–011 | one-shot |
| Run Throwing | 11 | 000, 002–011 | one-shot |
| Hurt | 10 | 001–006, 008–011 | one-shot |
| Falling Down | 6 | 000–005 | one-shot |
| Dying | 12 | 000–002, 006–014 | one-shot |

Two things to internalize:

- **Numbering has gaps** (`Running` skips 002, `Dying` skips 003–005). Vendors delete near-duplicate frames after export. This is harmless — Godot builds animations from an ordered file list, not from the numbers.
- **Some animations start at 001, not 000.** Also harmless, same reason.

### 3. Vendor extras — never imported

| File | What it is | What to do with it |
|---|---|---|
| `*.eps` | Vector source per part (Illustrator/Inkscape) | Archive. Useful only if you want to re-export parts at another resolution. |
| `Animations.scml` | Spriter project (the tool the vendor animated in) | Archive. We animate natively in Godot instead — but if you ever wonder what timing the vendor intended, Spriter's free edition can open it. |
| `Villager.unitypackage` | Unity import bundle | Archive or delete. Meaningless to Godot. |
| `readme.txt`, `license.txt` | Vendor docs + license terms | **Read the license**, then archive alongside the art. |

## Pack verification checklist

Run this on every pack *before* building anything on it. Broken downloads, re-zipped bundles, and marketplace previews masquerading as assets are all common.

1. **Open 3–4 part PNGs in an image viewer.** Each must show *only* its named component (a lone arm, a bare head) on transparency — **not** the whole character. A full character inside `Left Arm.png` means you have preview renders, not a cutout kit.
2. **Open the first and a middle frame of one animation** (e.g. `Running_000` vs `Running_005`). The pose must clearly differ.
3. **Check canvas sizes are uniform** — every PNG in a set must share one canvas size or the auto-alignment trick in guide 04 breaks. On Windows PowerShell:
   ```powershell
   Get-ChildItem *.png | ForEach-Object { $i=[System.Drawing.Image]::FromFile($_.FullName); "$($_.Name): $($i.Width)x$($i.Height)"; $i.Dispose() }
   ```
4. **Confirm real file types.** A quick paranoia check that nothing is mislabeled (Git Bash / WSL): `file * | grep -v "PNG image"` inside the pack folder should list only the `.eps`/`.txt`/`.scml`/`.unitypackage` files.
5. **Read `license.txt`** — confirm game use, whether attribution is required, and whether redistribution of the raw files (e.g. committing them to a public repo) is allowed.

> ⚠️ **Status of this repo's copy:** `example-asset-pack/` currently **fails check 1** — every part PNG (including `Sword.png` and `SlashFX.png`) contains a full-character render, and `readme.txt`, `license.txt`, `Animations.scml`, and `Villager.unitypackage` are actually PNG images too. The 216 numbered frames are genuine and pass check 2. Practically: guide 03 (frame-by-frame) works with this copy today; guides 04–05 (cutout) need the pack re-downloaded from its source first. The guides are written against the pack's *intended* contents.

## Next

→ **[02 – Importing the Asset Pack into Godot](02-importing-into-godot.md)**
