# Smore Simulator — Godot 4 Project

Production foundation for the cozy s'mores roguelike. This is a faithful port
of the web prototype's game logic (`/tmp/smore/game.js`) into idiomatic
Godot 4 GDScript.

## Open & run

1. Install **Godot 4.3 or newer** (4.x).
2. In the Godot project manager: **Import** → select `project.godot` in this folder.
3. Press **F5** (or ▶). The game runs at 512×384 logical resolution, stretched
   to your window.

Desktop controls for testing: drag with the mouse to move the stick, arrow keys
nudge it, `G`/`C`/`M` stack layers, `E` serves, `N` fresh mallow, `Enter` starts,
`R` restarts after game over / win.

## Export

1. Install export templates: **Editor → Manage Export Templates → Download**.
2. For Android: install the Android SDK + NDK and configure them under
   **Editor → Editor Settings → Export → Android**.
3. **Project → Export…** — presets exist for Linux, Windows Desktop, and
   Android (`com.sen2008.smoresimulator`, landscape).
4. The `export_presets.cfg` was hand-authored; open the Export dialog once and
   re-save so the editor normalizes it for your exact Godot version.

## Tuning mirror

All balance numbers live in `scripts/tuning.gd` and mirror the web prototype
exactly (nights, spawn timers, patience, heat rate, target windows, card and
event definitions). Change a number there and both logic and HUD follow.

## What's stubbed

- **Art**: programmer pixel-rects drawn in `_draw()` (park silhouettes, fire,
  campers, s'mores). No sprite assets yet.
- **Audio**: no sound yet (the prototype used WebAudio beeps; not ported).
- **Animation**: flame flicker, waterfall/river shimmer, stick wobble, and
  message/flash timers are in; nothing tweened.

See `SCAFFOLD_NOTES.md` for the full port checklist and next steps.
