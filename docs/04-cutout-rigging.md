# 04 – Building a Cutout Rig from the Vector Parts

Frame-by-frame (guide 03) replays the vendor's animations; a **cutout rig** lets you author your *own* — every part is a separate node you rotate and keyframe. This guide assembles `res://characters/villager/parts/` into a jointed character; guide 05 animates it.

## What the pack gives you to work with

The parts in `PNG/Vector Parts/` are **individually cropped** — each PNG is trimmed to its component (`body.png` 320 × 320, `head.png` 480 × 480, limbs 128 × 128 …). That means assembly is manual placement: each part gets positioned at its joint, guided by a reference frame. Two facts make this painless:

- **All parts share one export scale.** They fit each other 1:1 — no per-part scaling, ever.
- **The 900 × 900 animation frames were rendered 1:1 from the same source** (the Spriter project's canvas is exactly 900 × 900 — see `Animations.scml`'s `l/t/r/b` bounds). So a frame from `frames/idle/` can be used as a **tracing template**: parts laid over it at scale 1 line up exactly.

> Some packs instead export every part on one shared full-size canvas (part drawn in its assembled position, rest transparent). If you ever meet that style: stack all parts at one position and the character self-assembles; only the pivots need placing. Everything else in this guide applies unchanged.

## The rigging concept: pivots via `offset`

A `Sprite2D` rotates around its node origin. For a cutout limb, that origin must sit on the **joint** — the shoulder for an arm, the neck for a head. Godot gives two knobs:

- `position` — where the node origin sits (in the parent's space)
- `offset` — where the texture draws relative to that origin

Put the joint at the origin by setting **Centered = Off** and `offset = -(joint pixel inside the part image)`. Example: if the arm's shoulder socket is at pixel `(64, 20)` inside `arm-l.png`, then `offset = (-64, -20)`. Now `position` states where the shoulder sits on the body, and rotation swings the arm around the shoulder. That's the entire trick.

## 1. Set up the assembly scene

1. New scene → root **Node2D**, rename `VillagerRig`, save as `res://characters/villager/villager_rig.tscn`.
2. **Template:** drag `frames/idle/000.png` into the viewport as a child of `VillagerRig`, rename it `template`, set its **Position** to `(0, 0)` and **Centered = Off**. In the Inspector set **CanvasItem → Modulate**'s alpha to ~40 %. Click the lock icon in the toolbar so you can't select it by accident.
3. Work at scale 1 for the whole assembly — the root gets scaled once, at the very end.

## 2. Place the parts

For each part (start with `body.png`, then `head.png`, then limbs):

1. Drag the PNG from the FileSystem dock **onto the `VillagerRig` node** in the Scene dock (dropping on the node, not the viewport, creates it at `(0,0)`).
2. Inspector → **Offset → Centered = Off**.
3. **Set the pivot:** decide where this part's joint is *inside its own image* and put that pixel at the origin via `offset`:
   - Interactive: select the sprite in the viewport, hold **`V`**, click the joint — Godot moves the origin there and compensates the offset so the art doesn't shift. (Check your keymap if nothing happens; it's *Editor Settings → Shortcuts → "Set Pivot"*.)
   - Precise: type `offset = (-jx, -jy)` in the Inspector, reading `(jx, jy)` off the part in any image editor.
4. **Position it over the template** with the move tool (`W`) until it sits exactly on its ghost in the reference frame. Zoom in; the chibi style's thick outlines are forgiving, but joints should land within a pixel or two.

Where each pivot belongs:

| Part | Pivot (inside the part's image) |
|---|---|
| `body` | Hip line, bottom-center of the torso — the whole-character root joint |
| `head` | Neck: bottom-center of the head shape |
| `arm-l` / `arm-r` | Shoulder: the upper end of the arm's diagonal |
| `hand-l` / `hand-r` | Wrist: where the hand meets the arm sleeve |
| `leg-l` / `leg-r` | Hip: top of the leg |
| `sword` | The grip (the art is drawn horizontally, 400 × 128 — it inherits the hand's rotation) |
| `face-01` | Anywhere (it never rotates independently) — just position it on the head |
| `slash-fx` | Center is fine |

## 3. Build the hierarchy — straight from the vendor's rig

The pack's `Animations.scml` records how the vendor parented and layered these exact parts. Its draw order, back → front:

```
SlashFX · Sword · Left Hand · Left Arm · Left Leg · Right Leg
· Body · Head · Face · Right Hand · Right Arm
```

(The character faces right; their **left side is the far side**, so left limbs render behind the body, and both hands render behind their own arms. The sword rides in the far hand, behind the body.)

Reproduce both hierarchy and draw order with this tree — Godot draws children after their parent (in front) unless the child has **CanvasItem → Visibility → Show Behind Parent** enabled, marked ⏪ below. Drag nodes onto each other in the Scene dock to parent them; Godot preserves global placement when reparenting:

```
VillagerRig (Node2D)
├─ slash-fx            hidden (visible = off); first = drawn furthest back
└─ body                pivot: hips
   ├─ arm-l   ⏪       pivot: shoulder
   │  └─ hand-l ⏪     pivot: wrist
   │     └─ sword ⏪   pivot: grip (optional)
   ├─ leg-l   ⏪       pivot: hip
   ├─ leg-r   ⏪       pivot: hip
   ├─ head             pivot: neck
   │  └─ face          face-01.png
   └─ arm-r            pivot: shoulder
      └─ hand-r ⏪     pivot: wrist
```

Behind-parent flags cascade correctly: `sword` draws before `hand-l`, which draws before `arm-l`, which draws before `body` — matching the vendor's order exactly. Verify by eye against the template: nothing should change visually when the flags are right, because the template frame *is* the vendor's order.

Test the chains as you go: select `arm-r`, press **`E`** (rotate mode), drag — the arm should swing from the shoulder and carry the hand (and nothing else). Undo (`Ctrl+Z`) after each test swing; the saved scene should hold a clean rest pose.

## 4. Faces and props

- **Faces:** keep one `face` sprite and swap its `texture` at runtime for expressions:
  `$body/head/face.texture = preload("res://characters/villager/parts/face-02.png")` — all three face PNGs share the same 320 × 240 canvas, so the swap is drop-in.
- **Sword:** optional; delete the node for an unarmed villager, or toggle `visible`.
- **SlashFX:** stays hidden; guide 05 flashes it during the attack via a visibility track. It's parented to the rig root, not the hand — effects shouldn't inherit limb rotation mid-swing.

## 5. Finish: rest-pose checklist

- Delete (or hide) the `template` node.
- Root `VillagerRig`: **Scale** `0.3, 0.3` (matches the frame-by-frame character from guide 03; there's no physics shape under this node to worry about — collision lives on the `CharacterBody2D` that instances this rig in guide 05).
- Every sprite: `centered = off`, pivot on its joint, rotation `0`.
- Character assembled, visually identical to `frames/idle/000.png`.
- Scene saved.

## Aside: Skeleton2D and Polygon2D

Godot also offers a heavier route: `Skeleton2D` + `Bone2D` chains driving `Polygon2D` meshes with weight-painted deformation — that's how you get bending elbows and squashy torsos from a single texture. For a chibi pack with this few parts, the plain node hierarchy above is simpler, robust, and what guide 05 assumes. Revisit Skeleton2D only if you need smooth mesh deformation.

## Next

→ **[05 – Animating the Rig and Running It in Game](05-running-animations-in-game.md)**
