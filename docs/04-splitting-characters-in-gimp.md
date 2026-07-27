# 04 – Splitting Characters in GIMP (for Spine)

The character was generated, cleaned, background-removed, and upscaled in Scenario ([guide 02](02-generating-assets-in-scenario.md)). This guide covers GIMP's one job in the pipeline: **cutting that single image into separate body-part layers on one canvas, and reconstructing the hidden overlaps**, so Spine can animate it.

Written for **GIMP 3.0**.

> **Why split at all?** Spine animates by rotating *image attachments* on bones. A one-piece character can never swing an arm. And because the generated image shows parts occluding each other (the torso hides the top of the arm), splitting alone isn't enough — you must also **paint back the hidden pixels** at every joint, or the character tears apart the moment a bone rotates.

---

## Step 1 — Open and inspect the Scenario PNG

1. **File ▸ Open…** → `art/raw/characters/hero-a-pose.png` (the 2048×2048 upscaled, background-removed download).
2. Immediately **File ▸ Save As…** → `art/gimp/hero.xcf`. The XCF is the master; the PNG stays untouched in `raw/`.
3. Inspect at 200% zoom:
   - **Alpha edge quality:** the dark outline should end in a crisp 1–2 px falloff. If there's a light halo from background removal: **Layer ▸ Transparency ▸ Threshold Alpha…** (low threshold, ~0.1) usually cleans it; stubborn color fringes: select the halo with **Select ▸ By Color**, then delete.
   - **Pose check (last chance):** clear daylight between arms and torso? Both hands/feet fully visible? If not, go back to Scenario and regenerate — do not fight a bad pose in GIMP.
4. Rename the layer `source` in the Layers dock and **lock its pixels** (pixel-lock icon) — you'll only ever copy *from* it.
5. Helpers: drag a vertical guide down the character's center line (**Image ▸ Guides ▸ New Guide (by Percent)…**) for symmetry judgment.

## Step 2 — Create the target layer structure

Create empty layers (**Layer ▸ New Layer…**, Fill: Transparency) matching the standard part list, ordered top-to-bottom — **this order is the draw order Spine will use**:

```
arm-front         ← arm nearest the camera
hand-front
head              ← face + hair together for a simple character
torso
leg-front
foot-front
leg-back
foot-back
arm-back
hand-back
──────────────────
source (locked)   ← the untouched Scenario image, bottom
```

Naming rules (these names become filenames → Spine attachments → Godot):

- lowercase, hyphens, no spaces: `arm-front`, `hand-back`
- "front/back" = near/far side relative to the camera — never "left/right"
- identical part names across all characters (that's what enables Spine skins)
- splitting the face later? Add `hair`, `eyes`, `brow`, `mouth` above `head` — same technique, more layers

## Step 3 — Cut each part onto its layer

For each part, front-to-back (`arm-front` first):

1. Select the `source` layer in the Layers dock.
2. **Free Select tool (F)**, Antialiasing on, Feather off. Trace the part's boundary:
   - Along the **visible outline** where the part meets empty space — trace *outside* the dark line so the whole outline stays with the part.
   - Along the **joint seam** where the part disappears behind a neighbor (arm behind torso): cut in the middle of the dark seam line, or slightly on the *hidden* part's side. Don't agonize — this seam gets buried under the reconstructed overlap anyway.
3. **Edit ▸ Copy** (Ctrl+C), then **Edit ▸ Paste In Place** (Ctrl+Alt+V) — this pastes at the exact same canvas position.
4. Anchor the paste onto the right layer: the paste appears as a floating/new layer — name it as the part (`arm-front`), delete the pre-made empty placeholder of the same name, and drag the new layer into its slot in the stacking order.
5. **Select ▸ None** (Ctrl+Shift+A), next part.

Tips:

- Toggle already-cut parts invisible so you can see what remains uncut on `source`.
- The **head** overlaps the torso naturally in chibi art — include the full head down to where it visually ends behind the torso top; you'll extend it further in step 4.
- Symmetric parts are **not** mirror copies here (unlike hand-drawn art) — the generated image has unique pixels per side; cut each limb separately.
- When all ten parts are cut, toggle `source` off and view the stack: it should look identical to the original image. Thin gaps at seams are fine — step 4 fills them.

## Step 4 — Reconstruct the hidden overlaps (the critical step)

Every part must continue **past** its joint seam, ending in a rounded cap hidden behind its neighbor, so any rotation angle still looks connected:

```
visible arm        what the arm layer must contain
    ▐██                 ▐██
    ▐██                 ▐██
────┼──── torso     ────┼──── torso edge (reference only)
    (hidden)            ▐██   ← painted back in this step
                        ▝██▘  ← rounded cap under the torso
```

Overlap targets — extend each part by at least **the width of the joint**:

| Part | Extension | Hidden behind |
|---|---|---|
| arm-front / arm-back | rounded shoulder cap, +30–40% of arm length | torso |
| leg-front / leg-back | rounded hip cap, similar margin | torso |
| head | bottom edge continues 10–15% further down | torso |
| hand-front / hand-back | wrist stub into the arm | arm |
| foot-front / foot-back | ankle stub up into the leg | leg |

How to paint each extension (keep the covering neighbor visible at ~50% opacity so you can judge how far to go):

1. **Continue the fill:** Color-pick (**O**) the part's base color right at the seam, then extend the shape with a hard **Paintbrush (P)**. For larger areas, the **Clone tool (C)** — Ctrl-click a source point on the visible part, then paint into the extension — carries the painted texture across better than a flat fill.
2. **Continue the outline:** pick the outline color from the image (the style guide's dark warm brown, ~`#2a2020`), match the stroke width by eye against the part's existing outline (at 2048 px, typically 16–24 px), and close the extension with a **rounded cap** — never a flat chopped end.
3. **Continue the shading** if a cel-shadow tone runs into the seam — pick it and extend it a short way. Precision doesn't matter; this area is hidden in the rest pose.
4. **Test immediately:** solo the layer. The part must read as a complete, closed, self-contained shape. Then restore the neighbor's visibility and confirm the extension is fully covered in the rest pose.

> This step is 80% of the GIMP work, and it's what separates a riggable character from a broken one. Budget ~5 minutes per joint; a full character takes under an hour once practiced.

## Step 5 — Seam and edge cleanup

1. **Rest-pose check:** all part layers visible, `source` hidden. Toggle `source` on/off to compare — the assembled stack must match the original with no visible seams or slivers of missing pixels. Fix gaps by extending whichever part is *behind* at that seam (safer than editing the front part's visible silhouette).
2. **Stray pixels:** solo each layer and orbit its edges at 200% — delete crumbs left by loose selections.
3. **Alpha hygiene per part:** if any part shows halo remnants from the background removal, apply **Layer ▸ Transparency ▸ Threshold Alpha…** per layer, gently.

## Step 6 — Rotation test before leaving GIMP

Cheap insurance against redoing Spine work:

1. Duplicate `arm-front` (**Layer ▸ Duplicate Layer**).
2. **Rotate tool (Shift+R)**, drag the rotation pivot to the shoulder cap's center, rotate the duplicate ±45°.
3. The shoulder cap should stay hidden behind the torso, and the arm should look attached at every angle. If a gap opens, extend the cap (step 4) now.
4. Delete the duplicate. Spot-check the head and legs the same way.

## Step 7 — Final structure and save

```
hero.xcf  (2048×2048)
├─ arm-front       ├─ hand-front
├─ head
├─ torso
├─ leg-front       ├─ foot-front
├─ leg-back        ├─ foot-back
├─ arm-back        └─ hand-back
└─ source (hidden, locked)
```

- [ ] Ten part layers, correct names, correct stacking order
- [ ] Assembled stack matches the Scenario original
- [ ] Every part solos as a complete closed shape with a rounded hidden cap
- [ ] Rotation-tested shoulders, hips, and head
- [ ] `source` hidden (the exporter skips hidden layers), XCF saved

Next: [05 – Exporting from GIMP for Spine](05-exporting-from-gimp-for-spine.md).
