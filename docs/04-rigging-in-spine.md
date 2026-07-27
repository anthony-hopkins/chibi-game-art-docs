# 04 – Rigging the Character in Spine

This guide takes the PNG folder from [guide 03](03-exporting-from-gimp-for-spine.md) and builds an animation-ready skeleton in **Spine 4.2**.

> **License note:** basic rigging and animation work in Spine **Essential**. Meshes, weights, IK/transform/path constraints require Spine **Professional**. Pro-only steps are marked below and are optional for a simple chibi.

Spine has two modes, toggled with the big button in the top-left corner (or **Tab**):
- **SETUP** — build the skeleton, attach images. Everything in this guide happens here.
- **ANIMATE** — key motion over time (guide 05).

---

## Step 1 — New project and images path

1. Launch Spine → **New Project**. A project starts with one skeleton named `skeleton`; rename it `hero` (select it in the **Tree** panel, rename in the properties below).
2. In the Tree, select the **Images** node.
3. Set **Path** to your export folder, e.g. `C:/Users/Anthony/dev/games/art/export/hero` — use the **Browse** button. All ten PNGs appear under the Images node.
4. **Save immediately**: `hero.spine` next to your art (Ctrl+S). Spine stores the images path relative to the project file when possible — keeping the `.spine` file near the export folder keeps the project portable.

## Step 2 — Place the images

Because every PNG is full-canvas with a shared origin, placement is trivial:

1. In the Tree, expand **Images**.
2. Select **all** the image files (click first, Shift-click last).
3. Drag them together onto the **root** bone in the Tree (or into the viewport).
4. Spine creates one **slot + region attachment** per image. Select all the new attachments and set **X = 0, Y = 0, Rotation = 0** in the properties panel if they aren't already — all parts now overlap in exactly the GIMP arrangement.
   - If the character appears off-center relative to the origin cross-hair, select all attachments and offset them together (e.g., Y up by half the canvas) so the **feet sit on the origin** — the origin is the character's ground contact point in Godot.
5. Fix **draw order**: in the Tree, find the **Draw Order** node and drag entries so that, from front to back:

   ```
   hand-front, arm-front, head, torso, leg-front, foot-front,
   leg-back, foot-back, arm-back, hand-back
   ```

   (Front-most at the top of the Draw Order list.)

6. The viewport should now show the character exactly as it looked in GIMP. If any part is misplaced, you edited an attachment's position by accident — reset it to 0,0.

## Step 3 — Build the bones

Rule: **create a bone, then attach the matching slot/image to it.** Keep the hierarchy shallow and logical.

Target skeleton:

```
root
└─ hip
   ├─ torso
   │  ├─ head
   │  ├─ arm-front ─ hand-front
   │  └─ arm-back ─ hand-back
   ├─ leg-front ─ foot-front
   └─ leg-back ─ foot-back
```

How to create each bone:

1. Select the **parent** bone in the Tree (start by selecting `root`).
2. Choose the **Create** tool (bottom of the viewport toolbar, or press **B** twice if another tool is active — the tooltip says "Create").
3. **Click-drag in the viewport** from the joint's pivot point toward the part's tip:
   - `hip`: a short bone at the pelvis, pointing up. (Click at the pelvis, drag up slightly.)
   - `torso` (parent: hip): from pelvis to the base of the head.
   - `head` (parent: torso): from the "neck" point (top of torso) upward through the head. **The pivot is where the head rotates** — for chibi, put it right where head meets torso.
   - `arm-front` (parent: torso): from the shoulder cap center to the wrist.
   - `hand-front` (parent: arm-front): from the wrist to the fingertips.
   - Repeat for `arm-back`/`hand-back`, then `leg-front`/`foot-front`, `leg-back`/`foot-back` — leg bones pivot at the hip crease, foot bones at the ankle.
4. Name each bone as you create it (Spine prompts, or rename in the Tree). Use the same names as the images — future-you will thank you.

> **Pivot placement is the whole game.** A shoulder pivot placed too low makes the arm dislocate when it swings. Place every pivot at the center of the *overlap cap* you drew in GIMP (guide 02, step 4). Zoom in.

## Step 4 — Attach images to bones

Right now every slot hangs off `root`. Re-parent each slot to its bone:

1. In the Tree, drag the `head` **slot** onto the `head` **bone**. Spine asks how to handle the transform — keep the image where it is (Spine compensates the attachment offset automatically when you drag in the Tree).
2. Repeat for every slot → matching bone (`torso`→`torso`, `arm-front`→`arm-front`, etc.).
3. **Test every joint now:** switch to the **Rotate** tool, select each bone, and rotate it back and forth (then Ctrl+Z, or set rotation back to 0):
   - The part should pivot naturally from its joint.
   - The overlap cap should stay hidden behind the neighbor part at reasonable angles (±60°).
   - If a gap opens, either move the bone pivot, or go back to GIMP and extend that part's overlap (then re-export — rigging survives, see guide 03).

## Step 5 — Set up poses that survive animation

1. With everything at rest, **Ctrl+Shift+S (Save)**.
2. This rest arrangement is the **setup pose**. Every animation is stored as *offsets from setup*, so a clean symmetric setup pose keeps animation values sane.
3. Optional hygiene: select `root` and confirm the whole character sits with **feet at the origin**, facing the direction your game treats as "right".

## Step 6 (optional, Professional) — Meshes and weights for squash

Rigid rectangles are fine for a first character. Meshes make the torso/head flex organically:

1. Select the `torso` attachment → in properties, check **Mesh**.
2. **Edit Mesh** → **Generate** (automatic vertices) or place vertices by hand: a ring around the outline plus 2–3 interior points.
3. With the mesh selected, use **Weights** → **Bind** → pick `hip`, `torso`, `head` → **Auto** weights, then smooth manually so the torso's top follows `head` slightly (~20%) and its base follows `hip`.
4. Now head rotation gently drags the torso top with it — instant chibi squishiness.

Skip this entirely for your first rig; add it once idle/walk animations work.

## Step 7 (optional, Professional) — IK legs

For walk cycles, IK keeps feet planted:

1. Create a target bone per leg at the ankle, parented to `root` (name: `foot-front-ik`).
2. Select `leg-front` bone chain → **New… ▸ IK Constraint** → target `foot-front-ik`.
3. Repeat for the back leg. Now moving the target bone moves the foot, and the leg follows.

With single-bone chibi legs (no knee), IK is barely necessary — a straight FK rig animates these stubby legs just fine. Add IK only if you later split legs into upper/lower.

## Done — sanity checklist

- [ ] Bone hierarchy matches the diagram; every bone named
- [ ] Every slot parented to its matching bone; setup pose looks identical to the GIMP art
- [ ] Draw order correct (front hand/arm over head/torso, back limbs behind)
- [ ] Every joint rotate-tested with no gaps at ±60°
- [ ] Feet at origin, project saved as `hero.spine`

Next: [05 – Animating in Spine](05-animating-in-spine.md).
