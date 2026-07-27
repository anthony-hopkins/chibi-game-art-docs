# 05 – Exporting from GIMP for Spine

Goal: turn the layered `hero.xcf` from [guide 04](04-splitting-characters-in-gimp.md) into a folder of PNGs that drop into Spine perfectly aligned.

---

## The strategy: full-canvas PNGs

We export **one PNG per layer, each at the full canvas size** (2048×2048 for a character prepared per guide 04), with the part surrounded by transparency in its original position.

Why full-canvas instead of tightly cropped parts?

- **Alignment is automatic.** Every image shares the same origin, so in Spine you place all of them at position (0,0) and the character assembles itself exactly as drawn.
- **No offset bookkeeping.** Cropped parts require recording an x/y offset per part and entering it in Spine by hand — a reliable source of errors.
- **No wasted texture memory in the end product.** Spine's texture packer **strips the transparent whitespace automatically** when you export the atlas (guide 06), and it remembers the offsets for you. Full-canvas is only "expensive" during authoring, never in the shipped game.

## Step 1 — Naming convention (do this before exporting)

Layer names become file names become Spine attachment names. Fix the names in GIMP now:

- lowercase, hyphens, no spaces: `arm-front`, `hand-back`, `torso`
- no GIMP suffixes like `layer copy` or `#1`
- if you split the face later: `hair`, `eyes`, `brow`, `mouth`
- multiple characters: keep names identical across characters (`head`, `torso`, …) and separate them by **folder**, e.g. `export/hero/head.png`, `export/goblin/head.png`. Identical part names across characters is what makes Spine **skins** possible later.

Make sure the `source` layer (the original Scenario image) is **hidden** — both export methods below skip hidden layers, and a `source.png` in the export folder would end up as a stray attachment in Spine.

## Step 2 — Export the layers

Two GIMP 3-native ways, best first. Both must produce **full-canvas-sized PNGs** — that's the property the Spine step depends on. No Photoshop-era helper scripts are involved; alignment comes entirely from the full-canvas convention, and Spine reads plain PNGs.

### Option A — Batcher plug-in (recommended, built for GIMP 3)

**Batcher** (<https://kamilburda.github.io/batcher/>) is the actively maintained batch exporter written for GIMP 3's plug-in API (the modern successor to the old "Export Layers" plug-in from the 2.10 era).

1. Install Batcher per its site instructions (unzip into the GIMP 3 plug-ins folder shown at **Edit ▸ Preferences ▸ Folders ▸ Plug-ins**, restart GIMP).
2. **File ▸ Export Layers…**
3. Output folder: `export/hero/`. File extension: `png`.
4. In the export settings, make sure layers are exported **at image size, not layer size** — Batcher exposes this as a procedure/option ("Resize to image size" style option, or by *not* enabling any autocrop/"use layer size" option). Test one file and verify it matches the canvas size (2048×2048).
5. Ensure "only visible layers" style filtering is on so the hidden `source` layer is skipped.
6. Export, then spot-check two or three PNGs: full canvas size, part in its original position, transparent background.

Once configured, re-exporting the whole character after any art change is one menu action — this is why Batcher is the recommended default.

### Option B — Manual export (no plug-ins, always works)

Tedious but bulletproof; fine for a character with ~10 layers:

1. In the Layers dock, hide **all** layers (Shift-click a visibility eye toggles solo mode in GIMP — or just click the eyes off).
2. Show **only** `head`.
3. **File ▸ Export As…** → filename `export/hero/head.png` → Export (default PNG settings are fine).
4. Repeat for each part layer: show only that layer, **File ▸ Export As…**, type the part's name.

Because you export the whole visible canvas each time, the full-canvas alignment property holds automatically.

## Step 3 — Verify the export

Your output folder should look like:

```
export/hero/
├─ arm-back.png
├─ arm-front.png
├─ foot-back.png
├─ foot-front.png
├─ hand-back.png
├─ hand-front.png
├─ head.png
├─ leg-back.png
├─ leg-front.png
└─ torso.png
```

Checklist:

- [ ] Every file is exactly **2048×2048** (or whatever your canvas size is)
- [ ] Opening any file shows the part **in its original canvas position**, not centered/cropped
- [ ] Background is transparent (checkerboard), not white
- [ ] Filenames match layer names exactly, no spaces/uppercase
- [ ] No `source.png` in the folder

Quick way to verify all sizes at once in PowerShell:

```powershell
Add-Type -AssemblyName System.Drawing
Get-ChildItem export/hero/*.png | ForEach-Object {
  $img = [System.Drawing.Image]::FromFile($_.FullName)
  "{0}  {1}x{2}" -f $_.Name, $img.Width, $img.Height
  $img.Dispose()
}
```

## Re-exporting after art changes

You will iterate: rig in Spine, notice an overlap cap is too short, fix it in GIMP. The workflow tolerates this well **as long as names and canvas size never change**:

1. Edit the part layer in `hero.xcf` (extend the cap, clean an edge — or re-cut a part from a regenerated Scenario image pasted in at the same position).
2. Re-export that one layer (or all of them) to the same folder, overwriting.
3. In Spine, the images reload automatically (or press the refresh/reload images action). Bones, animations, and rigging are untouched — only the pixels update.

This is the single biggest payoff of the naming + full-canvas discipline.

Next: [06 – Rigging the Character in Spine](06-rigging-in-spine.md).
