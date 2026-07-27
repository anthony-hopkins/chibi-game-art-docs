# 05 – Animating the Rig and Running It in Game

The rig from guide 04 becomes a living character: keyframed idle/walk/slash animations authored entirely in Godot's `AnimationPlayer`, then a playable `CharacterBody2D` that walks and attacks from keyboard input — running live under F5.

Open `res://characters/villager/villager_rig.tscn` from guide 04.

## 1. Add the AnimationPlayer

1. Right-click `VillagerRig` → **Add Child Node** → `AnimationPlayer`.
2. Select it — the **Animation panel** docks at the bottom of the editor.

Everything in this guide happens with `AnimationPlayer` selected in the Scene dock; if the bottom panel ever shows something else, reselect the node.

## 2. First animation: `idle`

### Create it

1. In the Animation panel click **Animation → New**, name it `idle`.
2. Set **length** to `1.2` (seconds, field at the panel's top-right).
3. Click the **loop icon** (circular arrows, right of the length field) → loop enabled.
4. Set **Snap** (bottom of panel) to `0.1` so keys land on clean times.

### Key the rest pose at t = 0

An idle is a gentle breathe: body bobs a few pixels, head tilts a hair, arms sway.

1. Playhead at `0` (click the timeline ruler at 0, or type 0 in the time field).
2. Select the `body` sprite. In the Inspector, click the **key icon** (⧫) next to **Transform → Position** and next to **Rotation**.
3. First key pops a dialog — leave **Create RESET Track(s)** checked and confirm. (RESET is a special animation Godot uses to restore the editor/game to the neutral pose when nothing is playing; letting it capture the rest pose now saves pain later.)
4. Repeat the ⧫ on **Rotation** for `head`, `arm-l`, and `arm-r`. Tracks appear in the panel for every keyed property.

### Key the "inhale" at t = 0.6

1. Move the playhead to `0.6`.
2. Pose the mid-point — small numbers read best at chibi scale:
   - `body` Position: `y` −4 px from rest (type it in the Inspector; remember the rig's canvas is 900 px, so 4 px is subtle on purpose)
   - `head` Rotation: `−2`°
   - `arm-l` / `arm-r` Rotation: `±3`°
3. Click the ⧫ next to each changed property. (After the first key, ⧫ just adds a key to the existing track — no dialog.)

### Close the loop at t = 1.2

The last frame must equal the first or the loop pops. Box-select the keys at `t = 0` in the track area (drag a rubber band around them), `Ctrl+C`, move the playhead to `1.2`, `Ctrl+V`.

### Smooth it

Linear interpolation makes breathing look mechanical. Click a key to select it and set **Easing** in the key inspector that appears on the right of the panel (`0.5`-ish = ease-out; play with it), or box-select all keys of a track and change them together. For full curve control there's the **bezier editor** (curve icon, top-right of the Animation panel) — overkill for an idle.

### Preview

Press the panel's **Play** button (▶). The villager breathes in the editor viewport. Scrub the playhead — the pose follows. Iterate until it feels right.

## 3. Second animation: `walk`

1. **Animation → New** → `walk`, length `0.6`, loop **on**.
2. The pattern is opposing swings keyed at `0`, `0.3`, `0.6`:
   - t = 0: `leg-l` rot `+20`°, `leg-r` rot `−20`°, `arm-l` rot `−15`°, `arm-r` rot `+15`°, `body` y −3 px. Key everything (⧫).
   - t = 0.3: negate every value (legs/arms swap), `body` y back to rest. Key.
   - t = 0.6: paste the t = 0 keys (copy/paste as before).
3. Loop-preview and tune amplitudes; chibi legs are short, so ±20° reads as a full stride.

## 4. Third animation: `slash` (one-shot with an effect)

1. **Animation → New** → `slash`, length `0.5`, loop **off**.
2. `arm-r` rotation: t = 0 rest → t = 0.15 wind-up `−60`° → t = 0.3 swing `+80`° → t = 0.5 back to rest. Key each.
3. Give the swing snap: select the t = 0.3 key and set Easing to a sharp ease-in (< 1 accelerates into the hit).
4. **Effect flash** — this is where the pack's `slash-fx` sprite earns its keep. Select `slash-fx` (hidden since guide 04), and with the playhead at `0`, key **CanvasItem → Visibility → Visible** = off (⧫ creates a boolean track). At t = 0.28: key Visible = **on**. At t = 0.45: key Visible = **off**. The effect blinks in exactly during the swing.

## 5. Autoplay and first live run

1. In the Animation panel open `idle` and click the **Autoplay on Load** toggle (the "A▶" icon in the animation toolbar).
2. Save, press **F6**.

The rig breathes in a live game window — your first fully self-authored, engine-native animation. Close it.

## 6. Make it playable

### Input map

**Project → Project Settings → Input Map**: add actions `move_left`, `move_right`, `attack`; click **+** beside each and press the key to bind (A / D / J, plus the arrow keys if you like).

### Player scene

1. New scene → root **CharacterBody2D** named `Player`, save as `res://characters/villager/player.tscn`.
2. Drag `villager_rig.tscn` from the FileSystem dock onto `Player` — it instances as a child. Rename the instance `Rig`.
3. Add a `CollisionShape2D` child → Inspector → **Shape → New CapsuleShape2D** → size it over the villager's body (not the oversized head — gameplay collision should match the torso).
4. Attach a script to `Player`:

```gdscript
extends CharacterBody2D

const SPEED := 300.0
const GRAVITY := 1200.0

@onready var rig: Node2D = $Rig
@onready var anim: AnimationPlayer = $Rig/AnimationPlayer

var attacking := false

func _ready() -> void:
    anim.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += GRAVITY * delta

    var dir := Input.get_axis("move_left", "move_right")

    if Input.is_action_just_pressed("attack") and not attacking:
        attacking = true
        anim.play("slash")

    if not attacking:
        velocity.x = dir * SPEED
        if dir != 0.0:
            rig.scale.x = 0.3 * signf(dir)   # art faces right; mirror the rig, not the body
            anim.play("walk")
        else:
            velocity.x = 0.0
            anim.play("idle")
    else:
        velocity.x = 0.0

    move_and_slide()

func _on_animation_finished(anim_name: StringName) -> void:
    if anim_name == &"slash":
        attacking = false
        anim.play("idle")
```

Notes:

- `anim.play("walk")` every physics frame is safe — `AnimationPlayer` ignores `play()` for the already-playing animation.
- Mirroring flips the `Rig` child (`scale.x` sign), never the `CharacterBody2D` itself — negative scale on a physics body distorts collision. `0.3` is the rig scale chosen in guide 04; keep the magnitude, flip the sign.
- `animation_finished` fires only when a non-looping animation ends — exactly our one-shot `slash`.

5. Give the player a floor: in `player.tscn`'s parent world scene (or quickly in this scene for testing) add a `StaticBody2D` with a `WorldBoundaryShape2D` under the character, or temporarily comment the gravity lines.

### Run it

**Project → Project Settings → Application → Run → Main Scene** → `player.tscn` (or your world scene). Press **F5**.

- **A/D** — walks with your hand-keyed walk cycle, mirroring correctly.
- **J** — slash with the FX flash, movement locked for its 0.5 s, auto-return to idle.

The full loop — pack → import → rig → keyframes → input-driven playback — is now running live in the engine.

## 7. Optional upgrade: AnimationTree state machine

`if/else` animation code stops scaling around the third state. Godot's native answer:

1. Add an **AnimationTree** node to `player.tscn` (sibling of `Rig`).
2. Inspector: **Anim Player** → `$Rig/AnimationPlayer`; **Tree Root** → **New AnimationNodeStateMachine**; **Active** → on.
3. The AnimationTree bottom panel opens: right-click the graph → **Add Animation** → `idle`, `walk`, `slash`. Draw transitions by clicking the connect tool between nodes: `idle ⇄ walk` (both directions, **Switch Mode: Immediate**), `idle → slash` and `slash → idle` (set the return transition's **Switch Mode: At End** — the machine leaves `slash` automatically when the one-shot finishes, replacing the `animation_finished` plumbing).
4. Drive it from the script instead of `anim.play()`:

```gdscript
@onready var playback: AnimationNodeStateMachinePlayback = \
    $AnimationTree.get("parameters/playback")

# in _physics_process:
#   playback.travel("walk") / playback.travel("idle") / playback.travel("slash")
```

`travel()` routes through the transitions you drew, honoring At-End rules and any crossfade times you set on transitions (**Xfade Time** on a transition = free blending between poses — something frame-by-frame animation can never give you).

## Troubleshooting

| Symptom | Fix |
|---|---|
| Pose stays broken after scrubbing an animation in the editor | Play the `RESET` animation once, or fix the RESET track's values (Animation panel → RESET). |
| Loop pops at the wrap point | Last key ≠ first key on some track — re-paste the t = 0 keys at the end time. |
| Limb rotates around the wrong point in an animation | Its pivot moved: reassert `position == -offset` from guide 04 (a stray drag in move-mode is the usual culprit). |
| Character slides while attacking | `velocity.x` not zeroed during the attack branch. |
| Mirrored character's collision breaks | You flipped the `CharacterBody2D` instead of the `Rig` child. |
| `animation_finished` not firing for `slash` | The animation got loop enabled by accident — turn the loop toggle off. |
| AnimationTree ignores `anim.play()` calls | Expected: while `Active`, the tree owns playback — drive everything through `travel()`. |
