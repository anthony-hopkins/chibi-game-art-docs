# 08 – Getting Spine Characters into Godot

This guide exports the animated character from [guide 07](07-animating-in-spine.md) and gets it running in **Godot 4.4+** via the official **spine-godot** runtime — including placing it in a 2.5D scene like [2.5D-env-example.png](reference-images/2.5D-env-example.png).

> **Licensing:** the Spine runtimes require a valid Spine license per Esoteric Software's runtime license. If you own the Spine editor, you're covered — but ship builds must comply with the runtime license terms (<https://esotericsoftware.com/spine-runtimes-license>).

---

## Step 1 — Export from Spine

1. In Spine: **Spine menu (top-left) ▸ Export…**
2. Format: **JSON** while developing (human-readable, diffable). Switch to **Binary** (`.skel`) for release — smaller and faster to load. Both work identically in Godot.
3. Check **Texture Atlas ▸ Pack** — this is where the full-canvas whitespace from guide 05 gets stripped:
   - Open **Pack Settings**: enable **Strip whitespace X/Y**, **Rotation** on, **Premultiply alpha** ON (the Godot runtime's default materials expect PMA; if colors look fringed/dark in Godot, this setting is the first thing to check).
   - Max page size 2048×2048 is plenty for one chibi.
4. **Scale:** the split character came from a 2048 px canvas, but in-game it might render ~150–200 px tall. Export at a scale that matches your game resolution, e.g. **0.1–0.15**, rather than shipping 10× pixels and downscaling every frame. You can export multiple scales later if needed.
5. Output folder: export **directly into your Godot project**, e.g. `res://assets/characters/hero/`. You get three files:

```
hero.json     (or hero.skel)   ← skeleton, animations, events
hero.atlas                     ← where each part lives in the texture
hero.png                       ← packed texture page(s)
```

Re-exporting after animation tweaks: just export again over the same files; Godot reimports automatically.

## Step 2 — Install the spine-godot runtime

The official runtime is documented at <https://esotericsoftware.com/spine-godot>. Two supported forms:

- **Prebuilt Godot editor binaries** with the Spine module compiled in — download the build matching **both** your Godot version and your Spine editor version (e.g., "Godot 4.4 + Spine 4.2") from the spine-godot page. You run *this* Godot editor instead of the stock one.
- **GDExtension** build — an addon you drop into the project so the stock Godot editor works. Check the spine-godot download page for the extension package matching your versions.

Rules that save hours:

- **Major.minor versions must match between the Spine editor that exported the data and the runtime** (4.2 data ↔ 4.2 runtime). A mismatch fails to load with a version error.
- Everyone on the team (and CI) must use the same spine-godot build.

After installation, the editor gains new node types (`SpineSprite`) and resource types (`SpineSkeletonDataResource`, `SpineAtlasResource`).

## Step 3 — Set up the character scene

1. Copy/export the three files into `res://assets/characters/hero/` (if not already there). Godot imports `hero.png`; the `.atlas` and `.json` become Spine resources.
2. Create a new scene: **CharacterBody2D** (root, name `Hero`) — or `Node2D` for a prop.
3. Add a **SpineSprite** child.
4. In the SpineSprite inspector:
   - Create a new **SpineSkeletonDataResource** in the *Skeleton Data Res* slot.
   - Inside it, assign **Skeleton File** → `hero.json` and **Atlas Res** → new `SpineAtlasResource` pointing at `hero.atlas`.
5. The character appears in the viewport. Because we put the **origin at the feet** in Spine (guide 06), the SpineSprite's position is the ground contact — add your `CollisionShape2D` capsule around the body accordingly.
6. Save as `res://scenes/hero.tscn`.

## Step 4 — Play animations from GDScript

```gdscript
extends CharacterBody2D

@onready var spine: SpineSprite = $SpineSprite

const SPEED := 140.0

func _ready() -> void:
    var state := spine.get_animation_state()
    # Crossfade durations between any two animations (matches the
    # 0.15 s mix previewed in Spine, guide 07):
    spine.get_skeleton().get_data().set_default_mix(0.15)
    state.set_animation("idle", true, 0)   # name, loop, track

    # Receive the "hit" event keyed at the attack's strike frame:
    spine.animation_event.connect(_on_spine_event)

func _physics_process(_delta: float) -> void:
    var dir := Input.get_axis("move_left", "move_right")
    velocity.x = dir * SPEED
    move_and_slide()

    var state := spine.get_animation_state()
    var current := state.get_current(0).get_animation().get_name()

    if Input.is_action_just_pressed("attack"):
        state.set_animation("attack", false, 0)
        state.add_animation("idle", 0.0, true, 0)  # queue idle after
    elif current != "attack":
        if dir != 0.0:
            # Flip by scaling the sprite, and walk:
            $SpineSprite.scale.x = signf(dir) * absf($SpineSprite.scale.x)
            if current != "walk":
                state.set_animation("walk", true, 0)
        elif current != "idle":
            state.set_animation("idle", true, 0)

func _on_spine_event(_sprite: SpineSprite, _state, _entry, event: SpineEvent) -> void:
    if event.get_data().get_event_name() == "hit":
        _apply_attack_damage()

func _apply_attack_damage() -> void:
    pass # overlap query in front of the character, etc.
```

Key runtime concepts (they map 1:1 to what you built in Spine):

- **Animation state tracks**: track 0 = full-body animations. You can layer, e.g., a `blink` on track 1 without touching the walk on track 0.
- `set_animation` replaces the track now (with crossfade); `add_animation` queues after the current one — that's how attack returns to idle.
- **Events** keyed in Spine (guide 07, `hit`) arrive as the `animation_event` signal — gameplay stays frame-accurate no matter how you retime the animation later.

## Step 5 — Placing 2D characters in a 2.5D world

The environment reference is a low-poly 3D scene with flat-shaded surfaces; the chibi character stands in it as a flat 2D image. Two ways to achieve this in Godot, pick per project scope:

### Option A — Pure 2D with Y-sorting (simplest, recommended to start)

Fake the depth entirely in 2D, like most "2.5D" top-down games:

1. World root: `Node2D` with **Y Sort Enabled** checked.
2. Environment props (barrels, tables, walls) are `Sprite2D`s generated with the high-angle perspective baked in — that's exactly what the `three-quarter high-angle view` line in the prop recipes of [guide 03](03-scenario-prompt-library.md) produces. Floors use `TileMapLayer` with the seamless tiles from guide 03, section 6a.
3. Characters and props all children of the Y-sorted node → whoever is lower on screen draws in front, so characters walk in front of and behind props automatically. Keep each sprite's **origin at its ground contact point** (we already did this for the SpineSprite in Step 3).
4. Ground shadow: add a soft dark ellipse `Sprite2D` (30–40% opacity) as a child of the character, at the feet, *below* the SpineSprite. This replaces the baked shadows we deliberately excluded from the art.

### Option B — 3D world with billboarded 2D characters (matches the reference exactly)

The reference image is genuinely 3D (perspective on the walls, real lighting from torches). To replicate:

1. Build the environment from low-poly meshes in 3D (`Node3D` scene, meshes from Blender or GridMaps; flat-shaded materials, warm point lights at torches).
2. For each character, add a **SubViewport** containing the `SpineSprite`, and display it in the 3D world on a **Sprite3D** (set its *Texture* to the SubViewport via a ViewportTexture) with:
   - **Billboard: Y-Billboard** (faces the camera but stays upright),
   - **Alpha Cut: Discard** or opaque pre-pass to avoid transparency sorting issues,
   - **Shaded** off — the character's painted lighting should not fight the 3D lights.
3. Shadow: a `Decal` or a small dark quad under the character.
4. Move the character with `CharacterBody3D`; the SpineSprite only handles the visuals inside its viewport.

Option B is meaningfully more setup (one SubViewport per character type, viewport sizing, pixel density tuning). Ship your first playable slice with Option A; move to B only if you need real 3D camera movement like the reference.

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| "Skeleton version X does not match" on load | Spine editor and spine-godot runtime minor versions differ — re-export or switch runtime build |
| Dark halo / fringes around the character | Premultiplied alpha mismatch — re-export atlas with **Premultiply alpha** checked (Step 1) |
| Character floats above/below the floor | Skeleton origin wasn't at the feet — fix in Spine setup pose (guide 06, step 5), re-export |
| Parts pop apart during animation in-game but not in Spine | You edited art and re-exported PNGs but not the atlas — always re-export the atlas after art changes |
| Animations snap instead of blending | `set_default_mix` not set (or 0) — set it in `_ready` or per-pair in Spine's export settings |
| Character drifts sideways while walking | Root motion keyed into the walk loop — remove root translation keys (guide 07, walk step 4) |

---

That's the full pipeline: Scenario generation → GIMP split into aligned part PNGs → Spine rig → animations with events → Godot scenes. For the next character, the whole loop (guides 02–08) typically takes an afternoon, and iterating on art, rig, or animation afterwards touches only one stage at a time.
