# 03 – Frame-by-Frame Animation with AnimatedSprite2D

The fastest pack-to-screen route: the vendor already animated the character, so you just replay their frames. By the end of this guide the villager is idling, and switching to run/attack from the keyboard, **live in the running engine**.

Prerequisite: the project from guide 02, with frames at `res://characters/villager/frames/<animation>/<n>.png`.

## 1. Create the character scene

1. **Scene → New Scene**.
2. In the Scene dock click **Other Node** → search `CharacterBody2D` → **Create**. (Plain `Node2D` works if the character never needs physics; `CharacterBody2D` future-proofs it for guide 05's movement demo.)
3. Rename the root to `Villager` (double-click the name).
4. Right-click `Villager` → **Add Child Node** → `AnimatedSprite2D` → **Create**.
5. **Scene → Save Scene** (`Ctrl+S`) as `res://characters/villager/villager.tscn`.

## 2. Build the SpriteFrames library

`SpriteFrames` is the resource that holds every named animation and its frames.

1. Select the `AnimatedSprite2D` node.
2. In the Inspector, **Animation → Sprite Frames** → click `<empty>` → **New SpriteFrames**.
3. Click the newly created `SpriteFrames` resource — the **SpriteFrames panel** opens at the bottom of the editor.

The panel has an animation list on the left (one entry, `default`) and a frame strip on the right.

### Add the idle animation

1. In the animation list, double-click `default` and rename it to `idle`.
2. With `idle` selected, click the **Add frames from file** button in the frame-strip toolbar (folder icon — *not* the grid icon, which is for sprite sheets).
3. Navigate to `res://characters/villager/frames/idle/`, select `000.png`, press `Ctrl+A` to select all files, click **Open**.
4. All 18 frames appear in the strip, in file order. Gaps in the source numbering (see guide 01) don't matter — order is all Godot uses.

### Tune speed and looping

Top of the frame strip:

- **Speed**: `12` FPS. The strip's **play button** previews instantly in the viewport — judge with your eyes; vendor art usually sits well between 10 and 18 FPS.
- **Loop** (the circular-arrows toggle next to the animation name): **On** for idle.

### Add the rest

Click the **Add Animation** button (paper icon, top-left of the panel) for each remaining animation, rename it to match its folder, add its frames the same way. Recommended starting values:

| Animation name | Frames | FPS | Loop |
|---|---|---|---|
| `idle` | 18 | 12 | ✔ |
| `idle-blinking` | 16 | 12 | ✔ |
| `walking` | 23 | 18 | ✔ |
| `running` | 11 | 15 | ✔ |
| `jump-start` | 5 | 15 | ✖ |
| `jump-loop` | 6 | 10 | ✔ |
| `sliding` | 6 | 15 | ✖ |
| `kicking` | 11 | 15 | ✖ |
| `slashing` | 10 | 15 | ✖ |
| `slashing-in-the-air` | 11 | 15 | ✖ |
| `run-slashing` | 11 | 15 | ✖ |
| `throwing` | 9 | 15 | ✖ |
| `throwing-in-the-air` | 12 | 15 | ✖ |
| `run-throwing` | 11 | 15 | ✖ |
| `hurt` | 10 | 15 | ✖ |
| `falling-down` | 6 | 12 | ✖ |
| `dying` | 12 | 12 | ✖ |

You only need `idle`, `running`, and `slashing` to finish this guide — add the rest whenever.

## 3. Size and default state

The source frames are 900 × 900, which is enormous on screen:

1. Select `AnimatedSprite2D` → Inspector → **Transform → Scale** → `0.3, 0.3` (≈ 270 px tall on a 1080p viewport — tune to taste). Scale the *sprite*, not the root: the root's scale would also scale physics shapes later.
2. In the SpriteFrames panel select `idle` and click **Autoplay on Load** (the "A▶" toggle next to the animation name). The scene now starts animating by itself.

Editor-side check: with `AnimatedSprite2D` selected, tick **Animation → Playing** in the Inspector — the villager idles right in the editor viewport. Untick or leave it; autoplay governs the running game either way.

## 4. Run it live — first launch

1. Press **F6** (*Run Current Scene*).
2. First run of the project, Godot asks to select a main scene if you press F5 instead — choose `villager.tscn`, or set it later under **Project → Project Settings → Application → Run → Main Scene**.
3. A game window opens: the villager is standing at the top-left corner, idling at 12 FPS.

Top-left because the node sits at origin. Close the window (`F8` or click ✕), select the root `Villager` node and drag it near the viewport center (or set **Transform → Position** to e.g. `960, 540`), run again.

**That's a live, running animation** — everything past here is control.

## 5. Switching animations from code

Attach a script: right-click the `Villager` root → **Attach Script** → keep `res://characters/villager/villager.gd` → **Create**.

```gdscript
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
    # one-shots return to idle when they finish
    sprite.animation_finished.connect(_on_animation_finished)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):        # Space / Enter
        sprite.play("slashing")
    elif event.is_action_pressed("ui_right"):
        sprite.flip_h = false
        sprite.play("running")
    elif event.is_action_pressed("ui_left"):
        sprite.flip_h = true                        # art faces right; mirror for left
        sprite.play("running")
    elif event.is_action_released("ui_right") or event.is_action_released("ui_left"):
        sprite.play("idle")

func _on_animation_finished() -> void:
    # fires only for non-looping animations
    if sprite.animation in ["slashing", "kicking", "hurt", "throwing"]:
        sprite.play("idle")
```

Run with **F6**:

- **→ / ←** — run animation, mirrored correctly for direction.
- **Space** — one slash, then automatically back to idle (`animation_finished` only ever fires for non-looping animations, which is exactly the one-shot behavior we set in the loop column above).

The character doesn't *move* yet — animation and movement are deliberately separate concerns. Movement, plus doing all of this with a proper state machine, is guide 05 (its `CharacterBody2D` demo works identically whether the visuals are this `AnimatedSprite2D` or the cutout rig from guide 04).

## Troubleshooting

| Symptom | Fix |
|---|---|
| Frames imported in wrong order | Filenames must zero-pad to equal width (`000.png`, not `0.png`) — the guide-02 script preserves the vendor's 3-digit padding. |
| Animation plays once then freezes on last frame | Loop toggle is off for that animation in the SpriteFrames panel. |
| `animation_finished` never fires | It doesn't fire for looping animations — that's by design. |
| Villager blurry | Expected at scale 0.3 only if mipmaps are off — redo guide 02 §4. |
| Nothing plays on F6 | No autoplay set, and nothing calls `play()` — set **Autoplay on Load** on `idle`. |

## Next

→ **[04 – Building a Cutout Rig from the Split Parts](04-cutout-rigging.md)**
