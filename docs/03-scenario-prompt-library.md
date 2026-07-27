# 03 – Scenario Prompt Library

A complete, copy-paste prompt catalog for every asset type the game needs, matched to the style targets in [01 – Art Style Guide](01-art-style-guide.md) and the references ([characters](reference-images/Chibi-game-art.jpg), [environment](reference-images/2.5D-env-example.png)). Platform workflow (model, settings, cleanup) is in [guide 02](02-generating-assets-in-scenario.md).

**How to use this file:** take the shared blocks below, then a recipe from the relevant section, and assemble:

```
[SUBJECT from recipe] , [STYLE BLOCK] , [VIEW from recipe] , [BACKGROUND from recipe]
```

Swap the bracketed `{variables}` and keep everything else verbatim — consistency of wording is a big part of consistency of output.

---

## Shared blocks

### Character style block (use for all characters and creatures)

```
chibi game character, 2 heads tall, oversized head, no neck, tiny stubby
arms and legs, mitten hands, thick dark brown outlines, bold clean line art,
flat cel shading with single shadow tone, muted earthy color palette with
one saturated accent color, hand-painted 2D game art, sticker-like vector
style
```

### Prop / environment style block (use for objects, tiles, buildings)

```
stylized low-poly look 2D game asset, chunky exaggerated proportions,
flat-shaded surfaces with 2 or 3 tones, hard edges between color planes,
no outlines, warm terracotta and cool blue-grey palette, hand-painted
casual game art
```

(Per the style guide: characters are outlined, environment is **not** — keep the two blocks separate and never mix them.)

### Negative / avoid block (append everywhere)

```
realistic, photorealistic, 3d render, anime proportions, thin lines,
soft airbrushed shading, gradients, glow, blur, noise, text, watermark,
signature, cropped, out of frame, multiple characters, busy background,
drop shadow on ground
```

If the model doesn't accept a negative prompt field, append `— avoid: [the same list]` to the main prompt.

### Standard view/background lines

| Purpose | Line to append |
|---|---|
| Character for Spine rigging | `full body, front view, relaxed A-pose with arms angled away from body, legs slightly apart, centered, feet fully visible, isolated on plain light gray background` |
| Prop, single object | `single object, centered, three-quarter high-angle view, isolated on plain light gray background` |
| Floor tile / texture | `seamless repeating tile texture, top-down view, perfectly flat, even lighting, fills entire frame` |
| UI element | `flat 2D user interface element, straight-on view, centered, isolated on plain dark background` |
| Icon | `game inventory icon, straight-on view, centered, bold silhouette, isolated on plain dark background` |

---

## 1. Player characters and heroes

All character prompts use: **character style block + Spine rigging view line**. Generate 4–8, select against the rigging rules in guide 02 step 4, then split in GIMP ([guide 04](04-splitting-characters-in-gimp.md)).

**Swordsman hero**
```
chibi warrior hero with messy dark hair, determined angry eyebrows, small
amber eyes, brown leather tunic with belt, dark trousers, small brown boots,
empty hands
```
(Generate weapons separately — section 4 — so they can be a separate Spine slot. Hence `empty hands` on every character prompt.)

**Hooded rogue**
```
chibi rogue assassin, dark grey hood covering top of head, red scarf mask
over mouth, narrow glaring eyes, dark leather armor with straps, fingerless
mitten hands
```

**Battle mage**
```
chibi wizard, long white beard, bushy white eyebrows, deep blue hooded robe
with gold trim, small wooden pendant, tiny boots peeking under robe
```

**Crusader knight**
```
chibi knight, full metal great helm with cross-shaped visor slit, white
tabard with red cross over chainmail, metal gauntlet mittens, sturdy
metal boots
```

**Monk**
```
chibi monk, shaved head, calm heavy-lidded eyes, saturated orange robe
draped over one shoulder, simple rope belt, bare stub feet, wooden bead
necklace
```

**Viking raider**
```
chibi viking warrior, thick blonde braided beard, silver round helmet with
small horns, fur-trimmed leather vest, bare arms, wrapped boots
```

**Desert warrior**
```
chibi desert warrior, orange turban with small blue gem, dark pointed
beard, layered sand-colored robes with red sash, curved-toe shoes
```

### Alternate skins / armor tiers

Reuse the *same* base prompt and change only the outfit clause — with the seed locked to the approved base generation, silhouettes stay close and Spine **skins** become possible (same part names, new art):

```
{hero base prompt}, wearing iron plate armor tier with rivets        (tier 2)
{hero base prompt}, wearing gold ornate armor with red cape          (tier 3)
{hero base prompt}, wearing winter fur cloak and scarf               (seasonal)
```

### Expression sheets (for separate face parts)

If you split `eyes`/`brows`/`mouth` into their own layers (guide 04), generate a matching expression reference:

```
chibi character face expression sheet, same character repeated 6 times in
a grid: neutral, angry, happy, hurt, surprised, eyes closed, {character
description}, front view, plain light gray background
```
Use it as painting reference for the face layers — the grid itself is reference material, not a production asset.

---

## 2. Enemies

Same formula as heroes. Design rule from the style guide: each enemy gets **one readable silhouette hook** (horns, hood, crown, hunch) and one accent color.

**Goblin grunt**
```
chibi goblin, mossy green skin, huge pointed ears, wide toothy grin with
one snaggletooth, yellow eyes, ragged brown loincloth, hunched posture
```

**Skeleton soldier**
```
chibi skeleton warrior, oversized bone-white skull head with cracked crown,
hollow black eye sockets, ribcage torso, tattered purple and orange rags
```

**Cultist**
```
chibi hooded cultist, face hidden in shadow under grey hood except two
glowing yellow eyes, plain grey robe with small red gem clasp
```

**Slime**
```
chibi slime blob monster, rounded teardrop body, translucent teal jelly
with darker teal shadow tone, two simple oval eyes, tiny stub arms
```
(Slimes still get the Spine treatment: split into `body`, `face`, and 2–3 `blob` overlap pieces for squash animation.)

**Demon brute (mini-boss)**
```
chibi demon brute, deep red skin, large white curved horns, heavy jaw with
underbite fangs, fierce yellow eyes, black spiked shoulder armor, thick
short arms
```

**Royal tyrant (boss)**
```
chibi evil king boss, oversized gold crown with red jewel, long white
beard and mustache, furious white eyebrows, red and white royal robe with
gold trim, black gloved mittens
```

---

## 3. NPCs and villagers

Friendlier eyebrow angles, softer accents; otherwise identical formula.

```
chibi merchant, round cheerful face, raised friendly eyebrows, brown flat
cap, green apron over cream shirt, coin pouch on belt
```
```
chibi blacksmith, huge grey mustache, leather work apron over bare arms,
soot smudge on cheek, heavy dark gloves
```
```
chibi innkeeper woman, hair in a neat bun, kind closed-eye smile, blue
dress with white apron, small tray-carrying pose variant allowed
```
```
chibi village child, big curious eyes, tousled straw hair, patched oversized
tunic, barefoot
```
```
chibi old sage, bald with liver spots, extremely long white eyebrows and
beard, hunched, mustard-yellow robe, gnarled posture
```

---

## 4. Weapons and equipment

Weapons are generated **separately from characters** so each becomes its own Spine attachment (a `weapon` slot under the hand bone — guide 07). Use the **character style block** for hand-held items (they're outlined like characters, since they attach to characters) + prop view line, but replace the view with:

```
single weapon, straight-on side profile, blade pointing up, centered,
isolated on plain light gray background
```

```
chibi game weapon, short broad iron sword with round pommel, simple brown
grip, thick dark outlines, flat cel shading
```
```
chibi game weapon, curved scimitar with brass guard, worn blade with one
highlight streak, thick dark outlines
```
```
chibi game weapon, stubby battle axe with oversized head, wooden haft with
leather wrap, thick dark outlines
```
```
chibi game weapon, gnarled wooden wizard staff with small glowing teal
crystal at tip, thick dark outlines
```
```
chibi game weapon, short hunting bow with taut string, quiver with three
arrows as separate objects, thick dark outlines
```
```
chibi game shield, round wooden shield with iron boss and rim, two worn
plank textures, thick dark outlines
```
```
chibi game shield, kite shield with red cross on white field, dented iron
rim, thick dark outlines
```

Equipment as **inventory icons** (not attachments) uses the icon view line instead — see section 7.

---

## 5. Props and set dressing

These go **straight from Scenario to Godot** (no Spine, no GIMP splitting — at most a crop). Use the **prop/environment style block + prop view line**. Match the reference scene: warm terracotta props against cool stone.

Containers and loot:
```
fat wooden barrel with terracotta orange planks and dark iron bands
```
```
wooden crate with chunky planks, slightly askew lid
```
```
treasure chest, closed, rounded terracotta lid with gold trim and big lock
```
```
treasure chest, wide open, gold coins spilling over the rim
```
```
burlap sack of grain, plump and slouching, tied with rope
```
```
small pile of gold coins with two coins standing on edge
```
```
clay pot cluster, three rounded pots of different heights, one tipped over
```

Furniture and workplaces:
```
sturdy wooden table with thick legs, slightly oversized proportions
```
```
wooden stool, three fat legs
```
```
market stall with striped orange and cream canvas awning, crates of goods
under the counter
```
```
blacksmith anvil on a wooden stump, chunky and oversized
```
```
alchemist shelf with green and orange potion bottles, rolled scrolls,
small skull
```
```
cooking cauldron over small campfire, wooden ladle
```

Lighting and dungeon dressing:
```
wall torch in iron sconce, stylized teardrop flame with 3 flat flame tones
```
```
standing candelabra with three dripping candles
```
```
pile of rubble and broken stone blocks, blue-grey stone
```
```
broken stone pillar, cracked, moss on one side
```
```
iron portcullis gate section, heavy vertical bars
```
```
wooden signpost with two blank direction boards
```

Nature (for outdoor maps):
```
round chunky oak tree, dense dark-green canopy in 3 flat tone blobs, thick
short trunk
```
```
pine tree, stacked chunky triangle canopy tiers
```
```
small bush cluster, two rounded bushes with berry accents
```
```
boulder trio, rounded grey rocks of descending size, moss patches
```
```
tree stump with axe embedded, two mushrooms at base
```
```
wooden fence segment, two posts with two crossbars, slightly crooked
```

> **Variant tip:** every prop needs 2–3 variants to avoid repetition in maps. Lock the seed of the approved prop, then append `variant, slightly different shape` or change one clause (`one tipped over`, `damaged`, `mossy`).

---

## 6. Map and environment assets

The environment reference is a 3D-look scene; in 2D we rebuild it from **ground tiles + wall pieces + props** (props above). Use the **prop/environment style block**. Two asset types with different rules:

### 6a. Ground tiles (seamless textures)

Use the **tile view line** (`seamless repeating tile texture...`). Generate at 1024, test-tile immediately (Scenario's tiling preview, or in GIMP: **Filters ▸ Map ▸ Tile**). Expect to try several seeds — seams and obvious repeated features are the common failures.

```
seamless hexagonal stone floor tile texture, large cream and sand colored
hex flagstones, thin recessed gaps, subtle per-stone tone variation
```
(This is the dungeon floor from the reference image.)
```
seamless stone brick floor texture, large rectangular blue-grey blocks,
worn edges
```
```
seamless grass texture, two flat green tones in soft blob patches, tiny
scattered flowers
```
```
seamless dirt path texture, warm brown packed earth, scattered pebbles
```
```
seamless wooden plank floor texture, wide warm brown planks, visible nails
```
```
seamless shallow water texture, teal with lighter wave shapes, stylized flat
```
```
seamless sand texture, pale warm dunes with soft ripple lines
```

Transition strips (path-to-grass etc.) are easier to hand-assemble in GIMP from two tiles with a masked wavy edge than to generate; generate the two base tiles and blend.

### 6b. Walls and large structural pieces

Straight-on or high-angle single pieces, **prop view line** with `three-quarter high-angle view` replaced by `straight-on front view` for flat wall strips:

```
dungeon stone wall segment, large blue-grey blocks with darker recessed
mortar, torch-height, straight-on front view, isolated on plain background
```
```
dungeon wall corner piece, two stone wall segments meeting at right angle,
high-angle three-quarter view
```
```
stone doorway arch with heavy wooden double door, iron hinges
```
```
stone stairs, five chunky steps, high-angle three-quarter view
```
```
wooden bridge segment over gap, rope railings, slightly sagging planks
```
```
cliff edge piece, layered rock strata in two grey tones, grass lip on top
```
```
cottage building, chunky white plaster walls with wooden beams, oversized
terracotta roof, round door, high-angle three-quarter view
```
```
stone watchtower, round, crenellated top, arrow slit windows, high-angle
three-quarter view
```

### 6c. Full-map backdrops and vista layers

For non-playable background art (menu screens, distant parallax layers, world-map screen):

```
stylized game world map, top-down hand-painted map of a small kingdom,
green fields, dark pine forest, blue-grey mountain range, winding brown
roads, small chibi-scale village icons, parchment border
```
```
distant mountain range parallax layer, three overlapping flat-toned
blue-grey ridges, wide aspect ratio, isolated on transparent-friendly
plain sky band
```
```
night sky backdrop, deep purple-navy gradient bands, stylized flat stars,
large pale moon
```

### 6d. Map assembly note

Tiles and wall pieces are assembled in **Godot** (TileMapLayer for floors/walls, Y-sorted scenes for props — guide 08), not composited into one giant image. Generate pieces, not finished rooms. A generated "finished room" image is still useful once: as a **lighting/mood target** pinned next to the Godot scene while you place lights.

```
mood reference only: cozy dungeon storeroom at night, cream hex stone
floor, blue-grey walls, orange barrels and crates, warm torchlight pools
against cool shadows, high-angle view
```

---

## 7. UI and icons

Match the reference HUD: cream rounded panels, thick soft borders, chunky icons. Use the **UI / icon view lines**. Generate at 1024 and downscale — UI needs the crispest edges.

Panels and containers:
```
game UI panel, rounded rectangle, cream parchment fill, thick soft coral
border, subtle inner shadow, flat 2D user interface element, isolated on
plain dark background
```
```
game UI dialogue box, wide rounded rectangle, cream fill, thick warm brown
border, small name-tab on upper left corner
```
```
game UI button, rounded pill shape, warm orange fill with cream border,
unpressed state
```
```
game UI button, rounded pill shape, warm orange fill with cream border,
pressed state, slightly darker and flattened
```
```
game UI inventory slot, rounded square, dark leather-brown recessed fill,
lighter border
```
```
game UI progress bar frame with separate fill bar, rounded, cream frame,
red fill segment
```

HUD icons (from the reference: heart, bread, helmet):
```
game inventory icon, red heart with single white highlight, thick dark
outline, bold silhouette
```
```
game inventory icon, golden bread loaf with scoring lines, thick dark outline
```
```
game inventory icon, iron helmet with rounded dome, thick dark outline
```
```
game inventory icon, gold coin with embossed crown, thick dark outline
```
```
game inventory icon, healing potion, rounded flask with red liquid and
cork, thick dark outline
```
```
game inventory icon, iron key with heart-shaped bow, thick dark outline
```
```
game inventory icon, rolled parchment scroll with wax seal, thick dark outline
```
```
game inventory icon, leather pouch bulging with coins, thick dark outline
```

Icon sets must match each other even more than other assets: generate the whole set **in one session, same model version, same seed family**, and regenerate the whole set if the style shifts.

---

## 8. FX and animation support sprites

Most character motion is Spine's job, but flat effect sprites layer on top in Godot (as `AnimatedSprite2D` or particles). Use the character style block's outline treatment for effects that touch characters, and generate on **plain dark backgrounds** for easy additive compositing:

```
sword slash arc effect, single crescent swoosh, white core with teal edge,
thick stylized shape, flat 2 tone, isolated on plain dark background
```
```
hit impact spark, stylized star burst with 6 fat points, white and yellow,
flat 2 tone
```
```
dust puff, three rounded cream cloud blobs, flat 2 tone
```
```
magic glyph circle, teal rune ring with simple symbols, flat, no glow
```
```
sprite sheet, stylized torch flame animation, 6 frames in a horizontal row,
teardrop flame flickering, 3 flat orange and yellow tones, plain dark
background
```

> Frame-sheet generations (like the flame) come out with uneven frame spacing — plan to re-grid them in GIMP (rectangle-select each frame, paste into a uniform grid). For anything longer than ~6 frames, prefer Godot particles or Spine.

---

## 9. Coverage checklist for a vertical slice

Use this as the shopping list for a first playable dungeon level:

- [ ] 1 hero (A-pose, split, rigged, idle/walk/attack)
- [ ] 2 enemies (goblin + skeleton, same treatment)
- [ ] 1 NPC (merchant)
- [ ] 1 weapon + 1 shield (Spine attachments)
- [ ] Floor tile (hex stone) + wall segment + corner + doorway + stairs
- [ ] 6–8 props: barrel ×2 variants, crate, chest closed/open, table, torch, rubble
- [ ] HUD: panel, 3 resource icons (heart/bread/helmet), button ×2 states
- [ ] Inventory icons: potion, coin, key, scroll
- [ ] FX: slash, hit spark, dust puff, torch flame sheet
- [ ] 1 mood reference image for scene lighting

Every item above has a recipe on this page. Log approved prompts + seeds per guide 02, step 6.
