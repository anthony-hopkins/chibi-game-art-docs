# Prompt: Normalize Asset Packs into Staging

Paste the prompt below into Claude Code. Replace `<SCOPE>` with what you want converted — everything else is automatic.

---

## Prompt

Normalize the 2D character asset packs in `chibi-sprites/` into `staging/`, using the conventions below. Scope: **`<SCOPE>`** (e.g. `all packs`, `just the villager pack`, `the 21 skeleton-* packs`, `elf-archer and undead-archer`).

Do not modify anything under `chibi-sprites/` — copy only. Never flatten two source characters onto one staging name.

### 1. Explore before copying

Asset packs vary. Confirm the layout yourself rather than assuming; the shape below is what these packs use, but treat it as a starting hypothesis, not a guarantee.

```
chibi-sprites/<pack>/<Variant>/PNG/PNG Sequences/<Animation>/<frames>.png
chibi-sprites/<pack>/<Variant>/PNG/Vector Parts/<Part>.png
```

- A **pack** is a top-level folder in `chibi-sprites/` (already uniquely named).
- A **variant** is a character subfolder inside a pack, e.g. `Villager_1`, `Ghost_Knight_3`.
- Ignore these siblings — they are not characters: `AI/`, `EPS/`, `PSD/`, `GIF/`, `TXT/`, `Unity Package/`, `license.txt`, `Free Assets Craftpix!.url`.
- Ignore all non-PNG sources (`.ai`, `.eps`, `.psd`, `.svg`) and pre-rendered spritesheets/GIFs unless a character has no per-frame PNGs at all.

Known irregularities to handle, not to be surprised by:

- **`TXT/` sits at pack level** alongside the variants in ~20 packs. It is not a character.
- **Extra nesting**: the `gnoll` pack nests one level deeper (`gnoll/Gnoll/Gnoll_1`). Recurse to find the folder that actually contains `PNG/`; don't assume a fixed depth.
- **Companion sub-packs**: some variants contain a prop/effect folder with its own `PNG/` tree (`Ball/`, `Healing/`, `Blessed/`). Treat each as its own staging entry (see naming below).
- **Missing parts**: a few variants have `PNG Sequences/` but no `Vector Parts/`. That is fine — emit `frames/` only and note it.

### 2. Output layout (fixed convention)

```
staging/<character-name>/
  frames/<animation-name>/<frame-number>.png
  parts/<part-name>.png
```

### 3. Character names must be globally unique

This is the critical rule. **Variant folder names collide across packs** — `Archer_1` exists in five different packs, `Magician_1` in three, `Ghost_Knight_1` in two. Naming staging folders after the variant alone would silently overwrite characters.

Derive the name as **`<pack-folder-name>-<variant-number>`**, both lowercase kebab-case:

| Source | `<character-name>` |
|---|---|
| `villager/Villager_1` | `villager-1` |
| `elf-archer/Archer_1` | `elf-archer-1` |
| `undead-archer/Archer_1` | `undead-archer-1` |
| `gnoll/Gnoll/Gnoll_2` | `gnoll-2` |
| `mimic/Mimic_1/Ball` | `mimic-1-ball` |

- The variant number is the trailing integer of the variant folder name. If there is no trailing integer, kebab-case the whole variant name and append it to the pack name (dropping any segment that merely repeats the pack name).
- A companion sub-pack appends its kebab-cased folder name to its parent character.
- Before copying, assert every derived name is unique. Stop and report if two sources map to one name — do not silently suffix.

### 4. Animation frames → `frames/`

- **The animation folder name is authoritative** for `<animation-name>`; kebab-case it (`Idle Blinking` → `idle-blinking`, `Slashing in The Air` → `slashing-in-the-air`, `Run Shooting` → `run-shooting`).
- **The filename supplies only the frame number.** These packs use two interchangeable styles, and parsing the folder name instead of the filename handles both without special-casing:
  - `0_Orc_Archer_Shooting in The Air_000.png` (character-name prefix)
  - `Sliding_000.png` (no prefix)
- Name each copied frame with **only its sequence number, zero-padding preserved exactly**: `..._000.png` → `000.png`, `..._7.png` → `7.png`. The number is the trailing integer of the base filename; also handle `(3)` and `frame3` styles.
- Keep original numeric order. If a frame has no extractable number, number it by sorted position and flag it in the report.

### 5. Body parts → `parts/`

Copy each part PNG with a lowercase kebab-case name:

- Spaces → hyphens; split camelCase and letter/number boundaries: `Face 01.png` → `face-01.png`, `SlashFX.png` → `slash-fx.png`.
- Left/Right become `-l` / `-r` **suffixes**: `Left Arm.png` → `arm-l.png`, `Right Hand.png` → `hand-r.png`.
- Simple names stay simple: `Body.png` → `body.png`, `Sword.png` → `sword.png`.
- Expect: `Body`, `Head`, `Face 01–03`, `Left/Right Arm`, `Left/Right Hand`, `Left/Right Leg`, `Sword`, `Bow`, `Arrow`, `Shield`, `Weapon`, `SlashFX`, `Healing`. Cryptic one-offs (e.g. `bl.png`) — copy verbatim as `bl.png` and flag rather than inventing a meaning.

### 6. Verify and report

After copying:

- Per character: animation count, total frame count, part count.
- Any character missing `parts/`, or missing `frames/` entirely.
- Anything skipped or ambiguous — unnumbered frames, cryptic part names, unexpected folders — and what you did about it.
- **Confirm the copied PNG count equals the source PNG count you intended to copy**, and confirm no staging folder name was reused.

Report a per-character table only if the scope is small; for large scopes give totals plus the full list of anomalies.

---

## Reference: what this generalizes

The original `convert-assets.ps1` was hardcoded to one character:

- `PNG/PNG Sequences/<Anim>/0_Villager_<Anim>_<n>.png` → `staging/villager/frames/<anim-kebab>/<n>.png`
- `PNG/Vector Parts/<Part>.png` → `staging/villager/parts/<kebab-part>.png` via a hardcoded name map

The prompt above removes the hardcoded folder names and part map, and adds the two things a multi-pack run needs that a single-character script never had to consider: **pack-namespaced character names** (because variant names collide across packs) and **explicit handling of the irregular packs**.

## Scale in this directory

100 packs · ~299 character variants · ~5,050 animation folders · ~71,500 PNGs · 9.1 GB.
A full-scope run roughly doubles that on disk. Convert a single pack first and check the result before running everything.
