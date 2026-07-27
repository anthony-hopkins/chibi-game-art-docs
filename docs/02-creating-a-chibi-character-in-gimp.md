# 02 – Creating a Chibi Character in GIMP (for Spine)

This guide walks through drawing a simple chibi character in **GIMP 3.0** with every body part on its own layer, on a single canvas, ready for Spine rigging.

Style rules live in [01 – Art Style Guide](01-art-style-guide.md). Read that first.

> **Why separate layers?** Spine animates by rotating/moving *image attachments* on bones. If the arm is painted into the torso, it can never swing. Each part that moves independently must be its own image — and each part must be drawn *complete*, including the portion normally hidden behind neighboring parts.

---

## Step 1 — Create the canvas

1. **File ▸ New…**
2. Width/Height: **1024 × 1024 px** (a good working size — the character will occupy ~900 px of height; it gets scaled down in Spine/Godot).
3. Advanced options: **Fill with: Transparency**, color space RGB, 8-bit precision is fine.
4. **File ▸ Save As…** and save as `hero.xcf` (keep the XCF as your master file forever; PNGs are exports).

Turn on helpers:

- **View ▸ Show Grid** and **Image ▸ Configure Grid…** → 64 px spacing (gives you a 16×16 grid for proportions).
- Drag a vertical guide to x = 512 (**Image ▸ Guides ▸ New Guide (by Percent)…** → Vertical, 50%) — this is your symmetry line.

## Step 2 — Build the layer structure first

Create the empty layers before drawing so the part-based mindset is locked in from the start. In the **Layers** dock (Windows ▸ Dockable Dialogs ▸ Layers if it's not visible), create these layers top-to-bottom with **Layer ▸ New Layer…** (Fill with: Transparency):

```
sketch            ← rough drawing, deleted before export
──────────────────
arm-front         ← arm nearest the camera (character's left arm)
hand-front
head              ← includes face + hair for a simple character
torso
leg-front
foot-front
leg-back
foot-back
arm-back          ← arm on the far side, behind the torso
hand-back
```

Notes:

- **The layer order above is the draw order** (top of the list = in front). Spine will import this same stacking, so get it right here.
- **Naming matters.** These exact names become your Spine attachment/slot names and the exported filenames. Use lowercase and hyphens, no spaces. See [03 – Exporting from GIMP](03-exporting-from-gimp-for-spine.md) for the full convention.
- For a first character, keep **face and hair merged into `head`**. Later characters can split `hair`, `eyes`, `mouth` into their own layers for facial animation — same technique, more layers.
- "front/back" means near/far side of the body relative to the camera, not front-facing. For a side-view or 3/4-view character this is unambiguous; stick to it rather than left/right, which flips depending on whose left you mean.

Group them if you like (**Layer ▸ New Layer Group**, name it `character`) — groups are fine as long as the individual part layers stay separate.

## Step 3 — Sketch the character

1. Select the `sketch` layer.
2. Pick the **Pencil or Paintbrush tool (N / P)**, small hard brush, any visible color, low opacity if you prefer.
3. Block in the proportions from the style guide:
   - Head circle centered around x = 512, occupying the top ~50% of the character (roughly a 450–500 px circle).
   - Small rounded torso directly under it (no neck), ~30% of height.
   - Stub legs/feet in the remaining ~20%.
   - Sausage arms from the shoulder area, hanging slightly out from the body.
4. Draw the character in a **relaxed A-pose**: arms slightly away from the torso, legs slightly apart. Parts that touch are hard to cut apart; parts with daylight between them rig cleanly.
5. Reduce the sketch layer's **Opacity to ~30%** in the Layers dock, and **lock it** (click the pixel-lock icon) so you don't accidentally draw on it.

> Keep the pose symmetrical and neutral. All personality (poses, attitude) comes later from Spine animation — a neutral build pose animates best.

## Step 4 — Ink each part on its own layer

Work back-to-front (start with `arm-back`, end with `arm-front`) so you can see how parts stack.

For each part layer:

1. Select the part's layer in the Layers dock. **Double-check the layer name in the title bar of your brush strokes** — drawing on the wrong layer is the #1 mistake in this workflow.
2. Use the **Paintbrush (P)** with a **hard round brush**:
   - Size **10–12 px** for the outer silhouette line, **5–7 px** for interior lines.
   - Color: dark warm brown `#2a2020` (add it to your palette: click the foreground color → enter the hex → bookmark it).
3. Draw the **closed outline** of the part. Closed means no gaps — you'll bucket-fill inside it next.
4. **Draw the overlap.** This is the critical Spine rule:
   - The **top of each arm** continues into a rounded shoulder cap that sits *under* the torso — draw about 30–40% extra arm length past where the torso covers it.
   - The **top of each leg** continues up under the torso by a similar margin.
   - The **bottom of the head** extends down behind the torso's top edge.
   - **Hands** overlap into the end of their arm; **feet** overlap up into their leg.
   - Rule of thumb: every child part should overlap its neighbor by at least **the width of the joint**, and the hidden end should be **rounded**, so any rotation angle still looks connected.

   ```
   visible arm        what you actually draw on the arm layer
       ▐██                 ▐██
       ▐██                 ▐██
   ────┼──── torso     ────┼──── torso edge (for reference only)
       (hidden)            ▐██   ← keep drawing!
                           ▝██▘  ← rounded cap under the torso
   ```

5. Toggle the layer's visibility eye on/off frequently to check the part in isolation — it should look like a complete, closed shape on its own.

Use **Mirror Symmetry** to speed up the head and torso: with the Paintbrush active, open **Windows ▸ Dockable Dialogs ▸ Symmetry Painting**, choose **Mirror**, enable **Vertical symmetry**, and set the axis to x = 512. **Turn it off for arms/legs** — those are separate front/back layers, not mirrored strokes on one layer.

## Step 5 — Flat colors

For each part layer:

1. Select the part layer. Enable **Lock alpha? No — not yet** (we need to fill transparent interior).
2. Take the **Bucket Fill tool (Shift+B)**. In Tool Options:
   - **Fill by: Composite**, threshold ~40.
   - Check **"Fill similar colors"** and importantly **"Sample merged" OFF** (you want to fill based on this layer's own lines).
3. Click inside the outline with the part's base color. Chibi-ready base palette (adjust per character, keep it muted per the style guide):
   - Skin `#e8c39e`, hair `#3d3a37`, shirt `#8a6f4d`, pants `#4a4440`, boots `#5b4632`.
4. Zoom in and fix "fill leaks" and the anti-aliased gap between line and fill: a quick fix is **Select ▸ By Color** on the fill, **Select ▸ Grow… 2 px**, then bucket-fill inside the selection, **Select ▸ None**.

Keep every fill **inside the part's own layer**. If you fill on the wrong layer, undo (Ctrl+Z) immediately.

## Step 6 — Cel shading (one shadow tone)

For each part layer:

1. In the Layers dock, enable **Lock alpha** (the checkerboard lock icon) on the part layer — now paint can only land on already-painted pixels, so shading can't spill outside the shape.
2. Pick the base color with the **Color Picker (O)**, then in the color dialog drop **Lightness by ~15–20%** and nudge hue slightly toward warm purple. That's your shadow tone.
3. With a hard brush, paint the shadow shapes assuming **light from the top-front**:
   - Under the hair fringe onto the forehead.
   - A large crescent on the lower-right of the head (if your light is top-left).
   - A band across the top of the torso where the head casts a shadow.
   - The inner/lower side of arms and legs; the far-side (`-back`) limbs can be shaded slightly darker overall so they read as behind.
4. Optional single highlight (+10–15% lightness) on the top of the hair and any metal.
5. Disable Lock alpha when done with the layer.

> Hard-edged shadows only. If you catch yourself using a soft brush or gradients, stop — that's a different art style.

## Step 7 — The face

On the `head` layer (or separate `eyes`/`brows` layers if you split them):

1. **Eyes:** two flat almond/wedge shapes, dark outline, filled with the iris color (amber `#d99a2b` reads well). One tiny white highlight dot maximum.
2. **Eyebrows:** thick dark strokes angled sharply down toward the center — steeper angle = angrier. This is the main expression control.
3. **No nose.** Mouth: a short flat line, or nothing.
4. Keep all facial features in the **lower half of the head** — high foreheads are part of the chibi look.

## Step 8 — Optional texture pass

To get the faint speckle visible in the reference:

1. **Layer ▸ New Layer…** named `texture`, fill with Transparency, place it above all part layers *inside your character group*.
2. Fill it with 50% gray (`#808080`), then **Filters ▸ Noise ▸ HSV Noise…** (low dulling, value ~30).
3. Set the layer **Mode to Overlay** and **Opacity to ~8–12%**.
4. **Important:** this layer must be **merged down into each part before export or skipped entirely** — a texture layer that spans multiple parts can't be exported per-part. The simple options:
   - Skip it for characters (it matters more on large environment pieces), or
   - Apply the noise filter directly to each part layer (with Lock alpha on) instead of using a shared overlay layer.

## Step 9 — Review against the checklist

1. Hide the `sketch` layer (you'll delete it, or just leave it hidden — the exporter skips hidden layers).
2. Toggle each part layer solo and confirm: closed silhouette, complete overlap ends, shading contained.
3. Check the assembled character against the checklist at the bottom of [01 – Art Style Guide](01-art-style-guide.md).
4. Rotate-test the joints mentally (or roughly with the **Transform tool on a duplicate**): if you rotated the arm 45° at the shoulder, would the overlap cap still be hidden behind the torso? If not, extend the cap.
5. **Save the XCF.**

Your master file should now look like:

```
hero.xcf  (1024×1024)
├─ sketch (hidden)
├─ arm-front      ├─ hand-front
├─ head
├─ torso
├─ leg-front      ├─ foot-front
├─ leg-back       ├─ foot-back
└─ arm-back       └─ hand-back
```

Next: [03 – Exporting from GIMP for Spine](03-exporting-from-gimp-for-spine.md).
