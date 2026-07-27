# 07 – Animating in Spine

With the rig from [guide 06](06-rigging-in-spine.md), this guide creates the three animations every game character needs — **idle**, **walk**, **attack** — in Spine 4.2's Animate mode.

---

## The Animate mode tour (2 minutes)

Switch to **ANIMATE** mode (big top-left button, or **Tab**). New UI pieces:

- **Dopesheet** (bottom): rows per bone/property, diamonds are keyframes. Your main workspace.
- **Timeline/playback bar**: current frame, play/loop controls. Spine works at **30 fps** by default — fine for games.
- **Animations node** in the Tree: right-click ▸ **New Animation** to create clips.
- **Key buttons**: next to each property (Rotate/Translate/Scale) in the properties panel there's a small **key icon** — clicking it keys that property at the current frame. The keyboard shortcut **K** keys whatever transform you just changed.
- **Auto Key** (toolbar): when enabled, any change writes a key automatically. Powerful, dangerous — leave it off until you're comfortable.

Golden workflow: **pose → key → move playhead → pose → key**. Spine interpolates everything between keys.

---

## Animation 1 — Idle (breathing)

A chibi idle is a gentle vertical bob with tiny counter-motion. Target: **1.0–1.3 second loop** (30–40 frames).

1. Tree ▸ Animations ▸ right-click ▸ **New Animation** → name it `idle`. Double-click to make it the active animation.
2. **Frame 0 — key the base pose.** Select all bones (Ctrl+A in the viewport works, or select `root` and Tree-select all children) and key rotation + translation for everything (**K**). Every animation should start by keying its full starting pose — this prevents "leaking" poses between animations.
3. **Frame 15 (midpoint) — the exhale pose:**
   - Select `hip`: move it **down 8–12 px** (Translate tool), key it.
   - Select `torso`: rotate **~2° forward**, key.
   - Select `head`: rotate **~3° down** (heads lag the body — this overlap is what makes it feel alive), key.
   - Both arms: rotate **2–3° outward**, key.
4. **Frame 30 — copy frame 0.** In the dopesheet, box-select all frame-0 keys, **Ctrl+C**, move playhead to frame 30, **Ctrl+V**. First and last frames now match → seamless loop.
5. Set the animation's **duration to 30** frames (drag the loop end marker in the timeline) and press **Play** with looping on.
6. **Offset the head keys by 2–3 frames** (select the head's keys in the dopesheet, drag them right) so the head bobs slightly *after* the body. Cheap, huge realism win.
7. Curves: select all keys ▸ in the dopesheet, keys default to **Bezier** interpolation which auto-smooths — for idle this is exactly right. If the motion feels robotic, open the **Graph** view and flatten the tangents at frames 0/30.

> **Chibi rule:** small numbers. 2° rotations and 10 px bobs read as calm breathing on a big-headed character; 10° reads as aerobics.

## Animation 2 — Walk

Chibi walks are more **waddle** than stride — legs are too short for realistic gaits. Target: **0.6–0.8 s loop** (20–24 frames), i.e., a brisk toddle.

Use the classic 4-pose loop on a 24-frame timeline:

| Frame | Pose | What to key |
|---|---|---|
| 0 | **Contact A** | `leg-front` rotated forward ~25°, `leg-back` back ~25°, `hip` at normal height, `torso` leaned ~4° into travel direction |
| 6 | **Down/pass** | Both legs near vertical, `hip` **down 10 px**, arms passing neutral |
| 12 | **Contact B** | Mirror of frame 0 (front/back legs swapped) |
| 18 | **Down/pass** | Same as frame 6 |
| 24 | Copy of frame 0 | Copy-paste keys for a perfect loop |

Steps:

1. New animation → `walk`. Frame 0: key **all** bones (as with idle).
2. Pose and key the table's five columns. Pose tips:
   - **Arms swing opposite to legs** (`arm-front` back when `leg-front` is forward), ~20° swing.
   - **Head:** counter-rotate 2–3° against the torso lean, and offset its keys 2 frames late, same trick as idle.
   - **Feet:** if you rigged foot bones, tilt the lifting foot down ~15° as it trails.
   - The **hip bob at frames 6/18** is what sells the waddle — chibi characters bounce more than they stride. Try 10–14 px.
3. Loop it and watch the **silhouette**: at every frame you should clearly read which leg is forward. If legs blur together, increase the rotation angles — stubby legs need exaggeration to read.
4. **Do not translate `root` forward.** The character walks in place; Godot moves the character node through the world. Keying root motion into the loop makes the character drift in-game.

## Animation 3 — Attack (sword swing)

Non-looping, fast. Target: **~0.4 s** (12 frames): anticipation → strike → settle.

1. New animation → `attack`. Frame 0: key all bones at setup pose.
2. **Frames 1–4 — Anticipation:** rotate `torso` **back ~10°**, `arm-front` **up/back ~70°** (wind-up), `head` back ~5°. Key at frame 4.
3. **Frames 5–6 — Strike:** this transition is nearly instant — that's the punch. At frame 6: `torso` **forward 12°**, `arm-front` swung **down/forward ~120°** from the wind-up, `hand-front` rotated to extend the arc, `hip` dips 6 px. Key everything.
4. **Frames 7–12 — Settle:** ease back to a pose close to (but not exactly) setup by frame 12; the return should be slower than the strike.
5. Curve polish (Graph view): make frames 4→6 **fast-out** (sharp acceleration into the hit) and 6→12 **slow-in**. The asymmetry — slow wind-up, instant hit, soft recovery — is what makes it feel forceful.
6. Add an **event** for gameplay: Tree ▸ skeleton ▸ right-click **Events** node ▸ New Event → name `hit`. In the dopesheet's Events row, key the `hit` event at **frame 6**. In Godot you'll receive this event as a signal and apply damage exactly on the strike frame (guide 08).

> No weapon image yet? Animate the swing anyway with the empty hand — then add a `weapon` slot under `hand-front` later; the animation already works. (A weapon is one more Scenario generation — see the weapons section of [guide 03](03-scenario-prompt-library.md) — dropped into the images folder and attached to the hand bone. Weapons are single rigid pieces, so they skip the GIMP splitting step entirely.)

## Previewing like the game will

- **Playback ▸ loop** the walk while dragging the viewport — check it reads at small zoom (your in-game character may be ~150 px tall).
- Use **Preview** (Spine's preview view) to play animations with mixing: queue `idle` → `walk` → `attack` → `idle` and set default mix to **0.15 s** — this is roughly what crossfade will look like in Godot.

## Naming and housekeeping

- Animation names become the strings you type in GDScript: keep them lowercase and simple — `idle`, `walk`, `attack`, `hurt`, `death`.
- One skeleton = one character = all its animations in one `.spine` project.
- Save. Export comes next.

Next: [08 – Getting Spine Characters into Godot](08-spine-to-godot.md).
