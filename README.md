# Smore Simulator

A cozy roguelike cooking game about achieving the perfect marshmallow roast. Run a s'mores stand on a 5-night tour through America's national parks — "63 parks, one fire at a time."

## How to play (tour prototype)

Open `index.html` in a browser (no build step, no dependencies) — or play live at https://sen2008.github.io/smore-simulator/.

Survive a **5-night tour** through Yosemite, Zion, and Isle Royale with 3 reputation hearts:

- **Move** the roasting stick by dragging (touch) or mouse / arrow keys (desktop).
- Hold the marshmallow **over the flames** to roast it: white → golden → dark → burnt.
- Campers arrive with order bubbles showing the doneness they want (S = soft, G = golden, D = dark).
- **Stack** with the buttons (or G/C/M keys): graham → chocolate → mallow → graham, then **SERVE** (E).
- Match the doneness for perfect tips. If a camper's patience runs out, they storm off and you lose a heart. Lose all 3 and the tour ends.
- After each night, **draft 1 of 3 upgrade cards** (wider doneness windows, faster roast, extra heart...).
- Parks fight back: Zion has wind gusts that push the flames, Isle Royale gets lake storms that slow your roast.
- Night 5 is Festival Night: double campers, double tips. Survive it to become a **Legendary Roastmaster**.

Best score and tours won are saved in your browser.

## Full game

See [DESIGN.md](DESIGN.md) for the complete game design: the roguelike tour structure, all 63 national parks roadmap, Steam + Android launch plan, and art direction.

Built with plain HTML/CSS/JS on a 256×192 canvas.
