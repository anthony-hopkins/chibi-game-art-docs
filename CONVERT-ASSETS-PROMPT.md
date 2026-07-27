# Prompt: Normalize an Asset Pack into Staging

Copy the prompt below into Claude Code, filling in the two placeholders. It reproduces what `convert-assets.ps1` does for `Villager_1`, but works for any asset pack layout or file-naming convention.

---

## Prompt

I have a 2D character asset pack at `<SOURCE_PACK_PATH>` (e.g. `example-asset-pack/Villager_1`). Normalize its PNG assets into `staging/<CHARACTER_NAME>/` using the conventions below. Do not modify the source pack — copy only.

### 1. Explore the pack first

List the pack's directory tree before doing anything. Asset packs vary: the PNGs may live under `PNG/`, `Sprites/`, or the pack root; animation frames may be in per-animation subfolders or one flat folder distinguished by filename; body parts may be under `Vector Parts/`, `Parts/`, `PSD Parts/`, or similar. Identify:

- **Animation frame sequences**: sets of same-sized PNGs with an incrementing number in the filename (e.g. `0_Villager_Dying_003.png`, `hero-run_07.png`, `Attack (3).png`).
- **Individual body-part / prop images**: single PNGs named for a part (Body, Head, Left Arm, Sword, effects like SlashFX, etc.).
- Ignore non-PNG sources (PSD, AI, SVG, EPS) and any pre-rendered spritesheets/GIFs unless no per-frame PNGs exist.

### 2. Output layout (fixed convention)

```
staging/<CHARACTER_NAME>/
  frames/<animation-name>/<frame-number>.png
  parts/<part-name>.png
```

### 3. Animation frames → `frames/`

For each animation:

- Derive `<animation-name>` from the animation's folder name (or the animation token in the filename if there are no subfolders). Convert it to **lowercase kebab-case**: lowercase everything, replace spaces/underscores with hyphens (e.g. `Idle Blinking` → `idle-blinking`, `Slashing in The Air` → `slashing-in-the-air`). Strip character-name prefixes and junk tokens (e.g. a leading `0_Villager_`) so only the animation name remains.
- Name each copied frame using **only the frame's sequence number, preserved exactly as it appears in the source filename** (e.g. `..._000.png` → `000.png`, `..._7.png` → `7.png`). The number is the trailing integer in the base filename; also handle styles like `(3)` or `frame3`.
- Keep frames in their original numeric order. If a file has no extractable number but is part of a sequence, number it by its sorted position and note it in the summary.

### 4. Body parts → `parts/`

Copy each part PNG to `parts/` with a **lowercase kebab-case** name, applying these normalizations:

- Spaces → hyphens, insert hyphens at camelCase/number boundaries: `Face 01.png` → `face-01.png`, `SlashFX.png` → `slash-fx.png`.
- Left/Right sides become `-l` / `-r` **suffixes**: `Left Arm.png` → `arm-l.png`, `Right Hand.png` → `hand-r.png`.
- Simple names stay simple: `Body.png` → `body.png`, `Sword.png` → `sword.png`.

### 5. Verify and report

After copying, list the resulting `staging/<CHARACTER_NAME>/` tree and report:

- Each animation with its frame count.
- Each part file and the source file it came from.
- Anything skipped or ambiguous (duplicate names, unnumbered files, non-frame PNGs) and what you did about it.

Confirm total copied file count matches the number of source PNGs you intended to copy.

---

## Reference: original script behavior

`convert-assets.ps1` (Villager_1-specific) did exactly this:

- `PNG/PNG Sequences/<Anim>/0_Villager_<Anim>_<n>.png` → `staging/villager/frames/<anim-kebab>/<n>.png`
- `PNG/Vector Parts/<Part>.png` → `staging/villager/parts/<kebab-part>.png` via a hardcoded name map

The prompt above generalizes both steps so no hardcoded folder names or part maps are needed.
