# 02 – Importing the Asset Pack into Godot

Goal: a clean Godot 4.4+ project containing *only* the PNGs, renamed and foldered so every later step (SpriteFrames, rigs, scripts) reads naturally. Do the restructuring **before** the files ever enter the project — renaming inside Godot after import means fixing broken resource references forever after.

## 1. Create the project

1. Open Godot → **+ Create** → name it (e.g. `villager-demo`), choose an empty folder.
2. Renderer: **Forward+** (default) is fine for 2D; **Compatibility** if you target web.
3. Click **Create & Edit**. You land in the editor with an empty `res://`.

Set the window up for the art's scale right away — **Project → Project Settings → Display → Window**:

- **Viewport Width / Height**: `1920 × 1080`
- **Stretch → Mode**: `canvas_items`, **Aspect**: `keep` — the game scales cleanly to any window.

## 2. Restructure the pack on disk (outside Godot)

The pack already separates parts from frame sequences (`PNG/Vector Parts/` and `PNG/PNG Sequences/<Animation>/`); the remaining work is renaming — lowercase, hyphens instead of spaces, and the redundant `0_Villager_<Animation>_` prefix stripped from frame files. Animation folder names become the exact animation names in Godot.

Target layout — build it in a staging folder, not in the project yet:

```
staging/
└── villager/
    ├── parts/                 ← cutout kit (guide 04)
    │   ├── body.png
    │   ├── head.png
    │   ├── face-01.png … face-03.png
    │   ├── arm-l.png / arm-r.png
    │   ├── hand-l.png / hand-r.png
    │   ├── leg-l.png / leg-r.png
    │   ├── sword.png
    │   └── slash-fx.png
    └── frames/                ← frame-by-frame kit (guide 03)
        ├── idle/000.png … 017.png
        ├── idle-blinking/…
        ├── walking/…
        ├── running/…
        └── … one folder per animation
```

### Automated restructuring — PowerShell

Run from the folder that contains `example-asset-pack/`:

```powershell
$png = "example-asset-pack\Villager_1\PNG"
$dst = "staging\villager"

# frame sequences: PNG Sequences\<Anim>\0_Villager_<Anim>_<n>.png → frames\<anim-kebab>\<n>.png
Get-ChildItem "$png\PNG Sequences" -Directory | ForEach-Object {
    $anim = $_.Name.ToLower() -replace ' ', '-'
    $out = Join-Path $dst "frames\$anim"
    New-Item -ItemType Directory -Force $out | Out-Null
    Get-ChildItem $_.FullName -Filter *.png | ForEach-Object {
        if ($_.BaseName -match '_(\d+)$') {
            Copy-Item $_.FullName (Join-Path $out "$($Matches[1]).png")
        }
    }
}

# vector parts: Vector Parts\<Part>.png → parts\<kebab-name>.png
$partMap = @{
    'Body.png'='body.png'; 'Head.png'='head.png'
    'Face 01.png'='face-01.png'; 'Face 02.png'='face-02.png'; 'Face 03.png'='face-03.png'
    'Left Arm.png'='arm-l.png'; 'Right Arm.png'='arm-r.png'
    'Left Hand.png'='hand-l.png'; 'Right Hand.png'='hand-r.png'
    'Left Leg.png'='leg-l.png'; 'Right Leg.png'='leg-r.png'
    'Sword.png'='sword.png'; 'SlashFX.png'='slash-fx.png'
}
New-Item -ItemType Directory -Force "$dst\parts" | Out-Null
$partMap.GetEnumerator() | ForEach-Object {
    Copy-Item (Join-Path "$png\Vector Parts" $_.Key) (Join-Path "$dst\parts" $_.Value)
}
```

### Same thing — bash

```bash
png="example-asset-pack/Villager_1/PNG"; dst="staging/villager"
for d in "$png/PNG Sequences"/*/; do
  anim="$(basename "$d" | tr 'A-Z ' 'a-z-')"
  mkdir -p "$dst/frames/$anim"
  for f in "$d"*.png; do
    n="$(basename "$f" .png | sed -E 's/^.*_([0-9]+)$/\1/')"
    cp "$f" "$dst/frames/$anim/$n.png"
  done
done
mkdir -p "$dst/parts"
declare -A parts=( ["Body.png"]=body.png ["Head.png"]=head.png
  ["Face 01.png"]=face-01.png ["Face 02.png"]=face-02.png ["Face 03.png"]=face-03.png
  ["Left Arm.png"]=arm-l.png ["Right Arm.png"]=arm-r.png
  ["Left Hand.png"]=hand-l.png ["Right Hand.png"]=hand-r.png
  ["Left Leg.png"]=leg-l.png ["Right Leg.png"]=leg-r.png
  ["Sword.png"]=sword.png ["SlashFX.png"]=slash-fx.png )
for k in "${!parts[@]}"; do cp "$png/Vector Parts/$k" "$dst/parts/${parts[$k]}"; done
```

Everything else in the pack (`AI/`, `EPS/`, `Animations.scml`, `Unity Package/`, `TXT/`) goes to an **archive folder outside the project** — e.g. `art-source/villager-pack/`. Keep `Animations.scml` findable: guides 04–05 consult it for draw order and timing. If you must keep archive material inside the project folder, drop an empty file named `.gdignore` in its folder; Godot will skip it entirely.

## 3. Copy into the project

With the Godot editor open, copy `staging/villager/` into the project folder (drag into the **FileSystem dock**, or paste into the folder in Explorer):

```
res://characters/villager/parts/…
res://characters/villager/frames/…
```

Godot detects the files and imports every PNG automatically — you'll see a progress bar, then the folders appear in the FileSystem dock. Each PNG gets a sidecar `.import` file; commit those with the project, never edit them by hand.

## 4. Import settings for this art style

This is **high-resolution hand-drawn vector art**, not pixel art, and it will usually render *smaller* than its 900 × 900 source. That means:

1. In the FileSystem dock select `characters/villager` , then click the first PNG, Shift-click the last (multi-select works across the whole selection).
2. Open the **Import dock** (tab next to Scene, top-left).
3. Set **Mipmaps → Generate**: **On** — without mipmaps, art scaled below 100 % shimmers and aliases.
4. Leave **Compress → Mode** on `Lossless` (default for 2D) — no artifacts on clean line art.
5. Click **Reimport**. Wait for the bar to finish.

Filtering: Godot 4's default (`Linear`) is correct for this style — leave it. (Only pixel-art packs need **Project Settings → Rendering → Textures → Canvas Textures → Default Texture Filter = Nearest**.)

## 5. Sanity check

Drag `res://characters/villager/frames/idle/000.png` into an empty scene viewport — Godot creates a `Sprite2D`. The villager should appear crisp, on transparency, with no white fringe. Delete the node; the project is ready.

## Next

→ **[03 – Frame-by-Frame Animation with AnimatedSprite2D](03-frame-by-frame-animation.md)**
