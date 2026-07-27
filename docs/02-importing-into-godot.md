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

Rules: lowercase, hyphens instead of spaces, animation folder names become the exact animation names in Godot.

### Automated restructuring — PowerShell

Run from the folder that contains `example-asset-pack/`:

```powershell
$src = "example-asset-pack"
$dst = "staging\villager"

# frame sequences: 0_Villager_<Anim>_<n>.png  →  frames/<anim-kebab>/<n>.png
Get-ChildItem "$src\0_Villager_*.png" | ForEach-Object {
    if ($_.BaseName -match '^0_Villager_(.+)_(\d+)$') {
        $anim = $Matches[1].ToLower() -replace ' ', '-'
        $out = Join-Path $dst "frames\$anim"
        New-Item -ItemType Directory -Force $out | Out-Null
        Copy-Item $_.FullName (Join-Path $out "$($Matches[2]).png")
    }
}

# part PNGs: everything not frame-numbered and not a vendor extra
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
    Copy-Item (Join-Path $src $_.Key) (Join-Path "$dst\parts" $_.Value)
}
```

### Same thing — bash

```bash
src="example-asset-pack"; dst="staging/villager"
for f in "$src"/0_Villager_*.png; do
  base="$(basename "$f" .png)"
  anim="$(echo "$base" | sed -E 's/^0_Villager_(.+)_[0-9]+$/\1/' | tr 'A-Z ' 'a-z-')"
  n="$(echo "$base" | sed -E 's/^.*_([0-9]+)$/\1/')"
  mkdir -p "$dst/frames/$anim"
  cp "$f" "$dst/frames/$anim/$n.png"
done
mkdir -p "$dst/parts"
declare -A parts=( ["Body.png"]=body.png ["Head.png"]=head.png
  ["Face 01.png"]=face-01.png ["Face 02.png"]=face-02.png ["Face 03.png"]=face-03.png
  ["Left Arm.png"]=arm-l.png ["Right Arm.png"]=arm-r.png
  ["Left Hand.png"]=hand-l.png ["Right Hand.png"]=hand-r.png
  ["Left Leg.png"]=leg-l.png ["Right Leg.png"]=leg-r.png
  ["Sword.png"]=sword.png ["SlashFX.png"]=slash-fx.png )
for k in "${!parts[@]}"; do cp "$src/$k" "$dst/parts/${parts[$k]}"; done
```

Everything else in the pack (`.eps`, `.scml`, `.unitypackage`, readme, license) goes to an **archive folder outside the project** — e.g. `art-source/villager-pack/`. If you must keep it inside the project folder, drop an empty file named `.gdignore` in it; Godot will skip the folder entirely.

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
