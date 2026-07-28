# Scenario.gg Training Captions — Chibi Character Set

Captions for the Step 4 "Review Captions" screen when training the custom model on
`./reference-images/`. Paste each caption into the text box under its matching image.

## Captioning rules used (keep these for future training images)

- **Identical shared suffix** on every caption so the model anchors pose/framing:
  `standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.`
- **Identical style prefix**: every caption starts `A chibi …` — use the same word when
  prompting the trained model later (e.g. "A chibi pirate captain …").
- Only the **character-specific** details vary (gear, colors, hair, expression). Style traits
  the model should *absorb* (thick outlines, flat shading, big-head proportions) are left out
  of captions so they become part of the model itself rather than something you must prompt for.

## Captions by file

### valkyrie_Idle.png
> A chibi female valkyrie with a gray winged helmet, long silver-white hair, tan skin, green eyes, blushed cheeks, and a confident smirk, wearing a gray armored breastplate and holding a round ornate bronze shield at her side, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### archer_Idle.png
> A chibi rogue archer with long shaggy black hair, red war paint on his forehead, blue eyes, and a red cloth mask covering his mouth, wearing gray leather armor with a studded belt and a brown quiver of arrows on his back, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### barbarian_Idle.png
> A chibi shirtless barbarian with messy black hair, a thick black beard, and heavy stern brows, with a bare muscular chest, fur-trimmed shoulders, and a brown loincloth belt, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### girl_mage_Idle.png
> A chibi girl mage with a wide-brimmed navy witch hat with a light blue band, brown bobbed hair, pale skin, and a stern frown, wearing a navy robe with a light blue sash, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### medieval_knight_Idle.png
> A chibi hooded medieval knight with a black cowl trimmed in silver framing his stern face, wearing a dark tunic, a silver studded belt with a gold buckle, and brown pants, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### templar_knight_idle.png
> A chibi templar crusader knight in a full gray great helm with a brass cross on the front and a riveted visor slit hiding his face, wearing a white tabard with a red cross and armored gauntlets, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### whie_knight_idle.png
> A chibi white knight with a polished silver-white helmet with a dark gray crest and cheek guards, tan skin and a serious expression, wearing white armor with a red scarf and a leather chest strap, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### orc_idle.png
> A chibi green orc with a bald head, a black side ponytail tied with an orange band, pointed ears with a hoop earring, yellow eyes, and an underbite with small fangs, with a bare green chest and a ragged brown loincloth, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### vampire_idle.png
> A chibi vampire with slicked-back black hair with gray streaks, a widow's peak, pale skin, and amber eyes, wearing a dark formal suit with a red bow tie, white shirt, and white gloves, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### skull_warior_idle.png
> A chibi skull warrior with an oversized cracked white skull head with small horns and hollow black eye sockets, wearing a purple tunic with a gold collar, a belt, and an armored gauntlet, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### Death_Knight_Idle.png
> A chibi death knight with a black horned helmet trimmed in red with a red plume crest, a white skull face with glowing red eyes inside the visor, wearing black and red armor and holding a spiked red-rimmed shield, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### Zombie_Idle.png
> A chibi zombie with pale green skin, a red wound on his head, heavy dark green brows, narrowed white eyes, and small fangs, wearing a ragged brown tattered tunic, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### king_idle.png
> A chibi elderly king with a large golden crown set with a red jewel, long white hair, a white mustache and beard, and stern brows, wearing a red royal robe with white trim, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### foot_soldier.png
> A chibi foot soldier with a silver kettle helmet with a riveted band, brown hair, a full brown beard, and a scar on his cheek, wearing a dark gray gambeson and a brown belt with a gold buckle, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

### kings_guard_idle.png
> A chibi king's guard in full black armor with a silver visored helmet with gold trim and a golden plume crest, his face hidden behind the visor, holding a black and gold shield with a chevron emblem, standing in an idle pose, three-quarter view facing right, arms at sides, on a plain white background.

## Prompting the trained model later

Reuse the same skeleton when generating new characters so outputs land in-style:

```
A chibi [character type] with [head/hair/face details], wearing [outfit/gear details],
standing in an idle pose, three-quarter view facing right, arms at sides,
on a plain white background.
```
