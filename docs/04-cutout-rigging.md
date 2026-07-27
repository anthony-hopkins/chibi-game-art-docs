# 04 – Building a Cutout Rig from the Split Parts

Frame-by-frame (guide 03) replays the vendor's animations; a **cutout rig** lets you author your *own* — every part is a separate node you rotate and keyframe. This guide reassembles `res://characters/villager/parts/` into a jointed character; guide 05 animates it.

> ⚠️ Requires genuinely split parts. Run the guide-01 verification checklist first — the local copy of the example pack currently ships full-character previews in the part files (guide 01 has the details), so re-obtain the pack before following along against it.

## How the shared canvas becomes a free rig

Every part PNG is on the same 900 × 900 canvas, drawn in its assembled position. So if every part renders with its canvas top-left at the same point, the character reassembles pixel-perfectly. The entire rigging job reduces to two things:

1. **Stack all parts so their canvases coincide** (automatic alignment).
2. **Move each node's origin to its joint** (so rotating the node bends the limb at the joint, not around the canvas).

A `Sprite2D` gives us exactly the two knobs needed: `position` (where the node origin sits) and `offset` (where the texture renders relative to that origin). For a joint at canvas-pixel `(jx, jy)`:

```
centered = false
position = (jx, jy)        ← origin (rotation pivot) at the joint
offset   = (-jx, -jy)      ← texture slides back so the canvas stays in place
```

`position + offset = (0, 0)` always — the texture never moves; only the pivot does.

## 1. Find the joint coordinates

Open `parts/body.png` (or a full reference frame like `frames/idle/000.png`) in any image editor and read the pixel coordinates of each joint under the cursor. Record a table like:

| Joint | Canvas px (example placeholders) |
|---|---|
| hips (rig root) | `(450, 690)` |
| neck | `(455, 555)` |
| shoulder L / R | `(400, 600)` / `(510, 600)` |
| wrist L / R | `(370, 665)` / `(540, 665)` |
| hip L / R | `(420, 700)` / `(485, 700)` |

(The numbers above are illustrative — read yours off the actual art. Chibi proportions put the neck surprisingly low and the limb joints very close together.)

You can also do this inside Godot: drop the part into a scene and hover the art in the 2D viewport — the mouse's position shows in the viewport's bottom-left corner.

## 2. Assemble the parts

1. New scene → root **Node2D**, rename `VillagerRig`, save as `res://characters/villager/villager_rig.tscn`.
2. Select all files in `parts/` in the FileSystem dock (minus `face-02/03`, `sword`, `slash-fx` for now) and **drag them onto the `VillagerRig` node in the Scene dock** (not the viewport — dropping on the node creates them at position `(0,0)`). Godot creates one `Sprite2D` per PNG.
3. For every new sprite: Inspector → **Offset → Centered = Off**. All parts now render from the same top-left corner and the villager snaps together, whole, in the viewport.

If any part looks misplaced, its canvas size differs from the rest — recheck guide 01, step 3.

## 3. Set each pivot

For each part, apply the position/offset pair from your joint table. Two ways:

- **Precise (recommended):** type the values into the Inspector — `Transform → Position` = joint, `Offset → Offset` = negated joint.
- **Interactive:** select the sprite in the viewport, press and hold **`V`**, and click on the joint — Godot moves the node origin there while compensating the offset so the art doesn't shift. Fine-tune numerically afterwards; pivots placed by eye drift.

Body's pivot goes at the **hips** — that's the whole-character root joint (it's what you'll bounce for idle breathing and lean for runs).

## 4. Build the hierarchy

Rotating a shoulder must carry the hand along, so parent limbs in chains. Drag nodes onto each other in the Scene dock — Godot preserves each node's global placement when reparenting, so the assembled figure never shifts:

```
VillagerRig (Node2D)
└─ body            ← pivot: hips
   ├─ leg-l        ← pivot: left hip
   ├─ leg-r        ← pivot: right hip
   ├─ arm-l        ← pivot: left shoulder
   │  └─ hand-l    ← pivot: left wrist
   ├─ arm-r        ← pivot: right shoulder
   │  └─ hand-r    ← pivot: right wrist
   └─ head         ← pivot: neck
      └─ face      ← pivot: anywhere (it never rotates independently) — face-01.png
```

Test as you go: select `arm-r`, press **`E`** (rotate mode), drag — the arm should swing from the shoulder and take the hand with it. `R` by itself is select mode in Godot 4.4's default bindings; check the toolbar icons if your keymap differs. Undo (`Ctrl+Z`) after each test swing — the saved scene should hold a clean rest pose.

## 5. Fix the draw order

Godot draws the tree top-to-bottom, parents before children — so in the list above, `leg-l` draws over `body`, `head` draws over everything, etc. Compare against `frames/idle/000.png` and fix mismatches with either:

- **Reorder siblings** in the Scene dock (first child = drawn first = furthest back), or
- **CanvasItem → Visibility → Show Behind Parent** for a child that must render *behind* its parent (typical for the far arm: it's parented to `body` but the shoulder sits behind the torso), or
- **Z Index** for stubborn cases (e.g. the far leg at `z_index = -1`).

The far side of the character (the side away from the camera) is usually drawn darker by the vendor — that's the sprite that goes behind.

## 6. Optional parts

- **Faces:** `face-01/02/03` are swappable expressions. Keep one `face` Sprite2D and switch its `texture` at runtime (`$body/head/face.texture = preload("res://characters/villager/parts/face-02.png")`) — with `centered = false` and the same offset, every face lands correctly.
- **Sword:** child of `hand-r`, pivot at the grip.
- **SlashFX:** child of `VillagerRig` (not the hand — effects shouldn't inherit limb rotation mid-swing). Keep it hidden (`visible = false`); guide 05 flashes it during the attack animation.

## 7. Final rest-pose checklist

- Root `VillagerRig` at `(0,0)`, **Scale** `0.3, 0.3` on the *root* (the whole rig scales together; unlike guide 03 there's no physics shape under this node to worry about — collision lives on the `CharacterBody2D` that will instance this rig in guide 05).
- Every sprite: `centered = false`, `position == -offset`.
- Rotations all `0`, character assembled and matching `frames/idle/000.png`.
- Scene saved.

## Aside: Skeleton2D and Polygon2D

Godot also offers a heavier route: `Skeleton2D` + `Bone2D` chains driving `Polygon2D` meshes with weight-painted deformation — that's how you get bending elbows and squashy torsos from a single texture. For a chibi pack with this few parts, the plain node hierarchy above is simpler, robust, and what guide 05 assumes. Revisit Skeleton2D only if you need smooth mesh deformation.

## Next

→ **[05 – Animating the Rig and Running It in Game](05-running-animations-in-game.md)**
