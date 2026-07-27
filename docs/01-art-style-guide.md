# 01 – Art Style Guide

This guide defines the visual rules extracted from the two reference images. Every character and environment asset should be checkable against this page.

References:
- Characters: [Chibi-game-art.jpg](reference-images/Chibi-game-art.jpg)
- Environments: [2.5D-env-example.png](reference-images/2.5D-env-example.png)

---

## 1. Character style (chibi)

### 1.1 Proportions

The reference characters are roughly **2 heads tall**. Use this proportion map when blocking out a character on a 1024×1024 canvas:

```
┌──────────────────────────┐
│        (empty margin)    │  ~5%
│   ┌──────────────┐       │
│   │              │       │
│   │     HEAD     │       │  ~50% of character height
│   │              │       │
│   └──────┬───────┘       │
│      ┌───┴────┐          │
│      │ TORSO  │ arms     │  ~30%
│      └───┬────┘          │
│        ┌─┴─┐             │
│        legs+feet         │  ~20%
│   (empty margin)         │  ~5%
└──────────────────────────┘
```

- **Head:** about half the total character height, and *wider than the torso*. Slightly egg-shaped — wider at the cranium, tapering a little toward the jaw.
- **No neck.** The head sits directly on the torso and slightly overlaps it.
- **Torso:** short and rounded; shoulders are narrow and sloped.
- **Arms:** short, sausage-like, with almost no visible elbow. They hang at roughly 45° from the body in the rest pose.
- **Hands:** simple rounded mittens or fists. No individual fingers unless the pose demands it (e.g., gripping a sword — even then, at most a thumb).
- **Legs:** very short stubs, often mostly hidden by the torso/clothing.
- **Feet:** small rounded nubs or simple boots, no toe detail.

### 1.2 Faces

Faces carry almost all the personality in this style:

- **Eyes:** flat almond/wedge shapes, usually mid-height on the face. Colored iris block (amber, red, blue, or plain white) with **no pupil detail** beyond at most one small highlight.
- **Eyebrows:** thick, dark, and angled steeply downward toward the nose — the signature "determined/grumpy" look in the reference sheet. Eyebrow angle is the main emotion control.
- **Nose:** omitted entirely, or a tiny line/shadow.
- **Mouth:** small flat line or slight frown; often omitted. Facial hair (beards, mustaches) is drawn as bold solid shapes.
- **Ears:** simple C-shapes on the side of the head, only when not covered by hair or headgear.

### 1.3 Line work

- **Every shape gets an outline.** Line color is **very dark warm brown / near-black** (e.g., `#2a2020`), *not* pure black — pure black looks harsher than the reference.
- **Line weight:** thick and confident. At a 1024 px working canvas, use **8–12 px** for outer silhouette lines and **5–7 px** for interior detail lines. Outer lines are always heavier than inner lines.
- Lines have **rounded caps and joins** — no sharp pen tapers. This is a sticker-like, vector-flavored look.
- Interior details (clothing folds, hair strands) are drawn sparingly — a few bold interior lines, not sketchy hatching.

### 1.4 Color and shading

- **Palette:** muted but readable — desaturated warm skin tones, earthy clothing (browns, olive, slate, ochre) with **one saturated accent** per character (orange robe, gold crown, blue hair, red mask). Avoid neon or fully saturated fills.
- **Shading model: cel shading, exactly one shadow tone per color.**
  - Shadow tone = base color shifted **darker and slightly warmer/purpler**, roughly −15–20% lightness. No soft airbrushed gradients.
  - Light source is **top-front**, so shadows sit under the hair fringe, under the chin/head onto the torso, on the far side of rounded shapes, and under clothing overlaps.
- **Optional single highlight tone** on hair, metal, and the top of the head (+10–15% lightness). Metal (helmets, blades) gets a hard-edged highlight streak.
- **Subtle texture:** the reference art has a faint speckled/noise texture inside fills. This is an optional final pass (see guide 02, step 8) — keep it barely visible.
- **No baked-in drop shadow.** The oval ground shadows in the reference sheet are separate; in our pipeline the engine draws the shadow (guide 06).

### 1.5 Silhouette test

Fill the whole character with a single flat color. You should still be able to tell what the character is (helmet? hood? crown? weapon?). If not, exaggerate the headgear/hair/props — silhouette is what reads at small in-game sizes.

---

## 2. Environment style (2.5D)

The environment reference is a **stylized low-poly 3D scene viewed from a high-angle camera, with flat-shaded surfaces and 2D chibi characters standing in it**.

Key rules for environment assets:

- **Faceted, flat-shaded look:** large flat color planes per face, visible hard edges between faces, no smooth gradients across a surface. When drawing 2D environment sprites, fake this with 2–3 flat tones per object and hard edges between them.
- **Chunky, simplified geometry:** barrels, crates, tables, bottles are simple primitives with slightly exaggerated proportions (fat barrels, thick table legs) — matching the chibi exaggeration of the characters.
- **Palette:** warm terracotta/orange props and floors against cool desaturated blue-grey walls and shadows. Bounce warm light (torches) into an otherwise cool ambient scene.
- **Rounded UI:** panels and HUD elements are cream-colored rounded rectangles with thick soft-colored borders — same friendly rounded language as the characters.
- **Characters are 2D planes in the 3D world** (billboards). They keep their thick outlines, which visually separates them from the outline-free environment — this contrast is part of the look; don't outline the environment.

---

## 3. Quick checklist before calling an asset "done"

- [ ] Head ≈ 50% of character height, wider than torso, no neck
- [ ] Thick dark-brown outlines, heavier on the silhouette than interior
- [ ] Exactly one shadow tone per base color (plus optional single highlight)
- [ ] One saturated accent color max; everything else muted/earthy
- [ ] Eyebrows doing the emotional work; no nose; minimal mouth
- [ ] Passes the silhouette test
- [ ] Every body part on its own layer with overlap drawn (guide 02)
- [ ] No baked ground shadow
