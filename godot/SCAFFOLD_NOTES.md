# Scaffold notes — Smore Simulator Godot 4 port

Ported from the web prototype (`/tmp/smore/game.js`, v1.7 mechanics) without a
Godot binary on hand, so nothing here has been run yet. Written carefully
against Godot 4.3 GDScript; expect a first-open pass in the editor to catch
typos.

## What was ported (logic-identical to game.js)

- **Tour flow**: 5 nights, 3 hearts, park pool drawn without replacement,
  draft → event → night screens, win/lose.
- **Roast model**: heat zones (SCORCH 2.6× / SWEET 1× / cool 0.45×), flare-ups
  (1.2 s warning → 2.2 s at 2× heat), rain slowdown with tarp/windbreaker
  resists, wind park drifting the fire.
- **Fork**: second prong roasts in parallel; serving swaps the loaded prong.
- **Scoring order** (must stay exact): base 100/50/15 → critic zero/double →
  white-choc perfect ×1.4 → festival ×2 → craving ×1.5 → daredevil ×2 →
  streak (+25 %/perfect, reset on imperfect) → tips × flat + first-serve bonus.
- **All 16 draft cards** (as effect ids in `tuning.gd`, applied in
  `GameState.apply_card`), including once-owned filtering and `requires`
  gating for unlockables.
- **All 4 night events** (critic / storm / bus / quiet).
- **Ingredients**: milk/dark/Reese's/white/caramel, camper cravings, nightly
  trending chocolate drawn from the unlocked pool.
- **Meta-progression**: best score, wins, park passport stamps, white-choc on
  win, caramel at 3 stamps — persisted via `SaveData` (`user://smore_simulator.cfg`).
- **HUD**: roast meter with golden band, second-prong meter, zone label,
  streak, night/time, coins, hearts, park + trend line, transient messages,
  red flash on storm-out.

## What was simplified / stubbed

- **Art**: everything is `draw_rect` pixel blocks in `main.gd::_draw()`. Park
  backdrops are simple silhouettes (no wolf pack/howl yet on Isle Royale).
- **Audio**: not ported. The prototype's beeps (serve pop, storm-out sad trombone,
  sizzle, flare warning) should become AudioStreamPlayers.
- **Input**: one-finger drag moves the stick; the bottom 76 logical px are
  reserved for the touch buttons (also guards against `_input` firing before
  GUI consumes button touches). Multi-touch (drag + tap button simultaneously)
  works via Godot's normal touch pipeline but hasn't been tested.
- **Particles**: ember/rain/flame particles live in `main.gd`, mirroring the
  prototype's spawn rates.
- **Fonts**: `ThemeDB.fallback_font` — replace with a pixel font for the real
  art pass.

## Judgment calls

1. **Night length = 60 s**, not 90: the task brief said 90 but also said to
   mirror game.js exactly — game.js (source of truth) has `nightLength: 60`.
2. **Logic runs in 512×384 space directly** (prototype coords ×2), with layout
   constants in `tuning.gd` so logic and drawing share them.
3. **Cards use effect-id strings** instead of closures — GDScript `const`
   dictionaries can't hold lambdas; `GameState.apply_card` matches on the id.
4. **GameState is signal-driven** (`night_ended`, `tour_won`, `tour_lost`,
   `heart_lost`, `served`, `message`); `main.gd` builds draft/event buttons
   dynamically instead of the prototype's HTML overlay strings.
5. **`SaveData` is injected** into `GameState.save` by `main.gd` — logic stays
   node-free and unit-testable.

## Next steps to a playable build

1. Open in Godot 4.3+, run, and fix any first-open errors (most likely typos
   in node paths or the .tscn).
2. Playtest feel on desktop, then on an Android device — stick drag sensitivity
   and button sizes are the big unknowns.
3. Add audio (serve pop, flare warning, storm-out, win jingle).
4. Art pass: replace rects with real pixel-art sprites/tilemaps; add the Isle
   Royale wolf pack + howl.
5. Rebalance from playtests (the 60 s night length is still the open question
   from the prototype).
6. Export presets: re-save in the editor, install templates, produce the
   Android APK.
