# Smore Simulator — Full Game Design Document

**Version:** 1.5 (2026-09-25) — launch parks: CA, UT, Isle Royale; road to all 63
**Status:** Pre-production
**Repo:** github.com/sen2008/smore-simulator

---

## 1. High Concept

*"Overcooked meets Stardew Valley at a campfire."*

You run a s'mores stand touring through America's national parks. Campers line up with specific orders; you roast marshmallows over a living pixel fire to their exact liking, stack them with premium ingredients, and serve them up for coins and tips. Master the flame, draft upgrades between nights, and survive all 5 nights of the tour to become a Legendary Roastmaster — no two tours ever play the same.

**One-sentence pitch:** A cozy roguelike cooking game about achieving the perfect marshmallow roast.

## 2. Design Pillars

1. **The roast is the skill.** Fire mastery — not recipe memorization — is the core skill expression. Positioning, timing, and reading the flames separate good players from great ones.
2. **Cozy, never punishing.** Mistakes cost tips, not runs. No lives, no game-over shame spirals. The vibe is a warm campfire, even when it's hectic.
3. **Every campsite changes the rules.** New locations introduce new environmental twists so the core loop stays fresh across the whole campaign.
4. **Every tour is different.** Procedural nights, drafted upgrades, and random events mean no two runs play the same — mastery is adapting, not memorizing.

## 3. Target Audience & Positioning

- **Primary:** Cozy game players (Stardew, Unpacking, A Short Hike fans), 18–35, PC.
- **Secondary:** Score-chasers and speedrunners drawn to the mastery ceiling; parents/kids (E for Everyone tone).
- **Comps:** *Overcooked* (chaotic cooking), *Diner Dash* (order management), *Stardew Valley* (cozy progression).
- **Differentiator:** No cooking game has made fire itself the main mechanic. The roast meter is the hook; everything else supports it.

## 4. Core Loop (the roguelike run)

```
Start tour → Night N: biome + modifiers drawn → Serve campers, manage fire
→ Draft 1 of 3 upgrade cards → Traveling merchant (random stock) → Next night (harder)
→ Survive all 5 nights → LEGENDARY ROASTMASTER. Lose all reputation → tour over.
Between tours: unlock new biomes, tools, events, and perks (meta progression).
```

A tour is one run: ~10 minutes. A night is one shift (~90 seconds of serving + a quick draft). Full details in §9.

## 5. The Roasting System (core mechanic, in depth)

### 5.1 Heat zones
The flame is divided into three readable zones:
- **Cool edge** (outer flame): slow roast, very forgiving.
- **Sweet spot** (mid flame): ideal roast speed.
- **Scorch core** (base/center): roasts 3x fast, burns in seconds.

Players position the mallow, not just time it. Zone is shown via flame color and a subtle indicator ring.

### 5.2 Doneness scale
Raw → Soft → **Golden** → Dark → Burnt. Each order specifies a target (e.g., "golden, not a shade darker"). A 5-stage meter with a marked target zone; colorblind-safe (icon + label, never color alone).

### 5.3 Marshmallow types
| Type | Behavior | Unlock |
|---|---|---|
| Classic | Balanced roast speed | Start |
| Jumbo | Roasts slow, bigger tips, feeds 2 orders | Campsite 2 |
| Mini | Roasts very fast, high burn risk, quick serves | Campsite 3 |
| Stuffed | Chocolate core; roast level also melts filling — under-roast = solid core complaint | Campsite 4 |

### 5.4 Environmental twists
- **Wind gusts** (Lakeshore+): push flames sideways; telegraphed by leaves/grass animation. Reposition or wait it out.
- **Fire health** (Snowy Peaks): fire dies over time; stoke with bellows (minigame timing) or it goes out and roasting stalls.
- **Flare-ups** (Desert): grease drips cause flare columns — free fast-roast if you're brave, instant burn if you're greedy.

### 5.5 Tools (upgrades)
- **Basic stick** — 1 mallow.
- **Rotating spit** — even roast (no hot-spot penalty), but slower handling.
- **Double-prong fork** — roast 2 mallows at once; each has its own doneness.
- **Bellows** — stoke fire on demand; overuse causes flare-ups.
- **Insulated glove** — hold mallows closer to scorch core without penalty.

## 6. Assembly & Recipes

- Base formula: cracker → chocolate → mallow → cracker, but recipes expand: double-stacks, open-face, drizzle toppings.
- **Recipe book:** 24 recipes across the campaign; discovered by serving or bought as "secret recipes." Filled book = completionist hook.
- **Signature combos:** serving the same camper's favorite 3 days running unlocks a named signature s'more with bonus tips permanently.
- Assembly is quick by design (click/drag ingredients) — the challenge is doing it *while* mallows roast.

## 7. Customers & Orders

- **Patience meters:** serve fast for tip multipliers; patient campers tip for perfection over speed — pick your strategy per customer.
- **Personalities:**
  - *Kid* — impatient, simple orders, small tips.
  - *Food critic* — appears rarely; extremely picky, massive tip + star progress.
  - *Ranger* — bulk orders (4–6 s'mores), great for combos.
  - *Couple* — matching orders; serve both golden for a "romance bonus."
- **Rush hours:** telegraphed crowd waves; optional to trigger early for bonus ("ring the dinner bell").

## 8. Economy & Progression (run vs. meta)

**Within a tour (run economy):**
- **Coins:** base pay per serve + tip (accuracy × speed × customer generosity). Coins are spent *during* the tour — they don't carry over.
- **Reputation (hearts):** start each tour with 3 hearts. A camper who storms out costs 1 heart. Zero hearts → tour over. Cozy roguelike: losing a tour still earns meta progress, never feels wasted.
- **Between-night draft:** after each night, choose **1 of 3 upgrade cards** (tools, perks, ingredients — see §5.5). Cards synergize (e.g., Double-prong fork + Sugar rush = mini-mallow machine). One reroll per tour, costs coins.
- **Traveling merchant:** 3 random items per night (tools, ingredients, heart refill at a painful price). Randomized stock forces adaptation — you can't plan a build, you *discover* one.

**Between tours (meta progression):**
- **Campfire Tales (XP):** earned from tours (win or lose) and achievements. Spend to unlock: new biomes, mallow types, tool blueprints (added to the draft pool), night events, stand skins, starting perks.
- **Recipe book:** persists across tours; 24 recipes to discover — the completionist thread.
- **Park Passport:** modeled on the real NPS Passport program — each park cleared earns its cancellation stamp in your passport. 7 stamps at launch, 63 total as Park Packs release. The passport screen is the visible trophy collection; players will screenshot it.
- **No grind wall:** a skilled player can win a tour with base unlocks; meta progression widens options and margins, never gates victory.

## 9. The Tour (roguelike run structure)

A tour = **5 nights**, ~10 minutes. Win by surviving night 5. Lose when reputation hits zero.

Pacing is brisk by design: ~90 seconds of serving per night, then a 20-second draft/merchant breather. Short runs mean low commitment, high "one more tour" energy — and 10-minute sessions play great on Steam Deck in handheld mode.

### 9.1 Night generation
Each night draws from the unlocked **biome pool** (no repeats until the pool is exhausted):
### Launch parks (7)

**California**
1. **Yosemite** — granite cliffs, waterfall, golden-hour pines. Calm fire, simple orders. Weighted to appear early; the tutorial park.
2. **Joshua Tree** — twisted Joshua trees, desert night sky, Milky Way. Night-only; low light makes doneness harder to read — trust the meter, not your eyes. Unlocks Minis (quick night bites).
3. **Sequoia** — towering sequoias, ground fog, damp air. Fire health mechanic: damp wood means working the bellows to keep the fire alive.

**Utah (Mighty 5, starting with 3)**
4. **Zion** — sheer canyon walls, cottonwoods, the river glinting below. Wind gusts funnel through the canyon — telegraphed, reposition or wait. Unlocks Jumbo mallows.
5. **Bryce Canyon** — hoodoo amphitheater cycling sunrise hues. Rapid temperature swings: roast speed drifts up and down through the night — watch the flames, not the clock.
6. **Arches** — Delicate Arch on the skyline, slickrock fins, heat shimmer. Intense desert heat: everything roasts faster, flare-ups common.

**Michigan**
7. **Isle Royale** — Lake Superior shoreline, loons on the water, moose wading the shallows at dusk, a wolf pack crossing the far ridgeline at night — a nod to the island's famous wolf-moose study. Sudden lake storms roll in: rain douses an unsheltered fire — keep the tarp handy (draftable gear). Unlocks Stuffed mallows. Finish a night with full hearts and you'll hear the pack howl in approval.

### Night 5: Festival Night
No fixed finale park — night 5 draws from the pool like any night, but always rolls the **Festival** event: string lights go up, rush crowds, all mechanics in play, critic visits. Any park can host the festival.

### The long road: all 63
Launch ships 7 parks. Post-launch **Park Packs** (free updates, 3–4 parks each) work toward all 63 national parks — each with its own vista, mechanical twist, and passport stamp. *"63 parks, one fire at a time"* is the live-service spine: years of content, and every pack is a marketing beat.

Each night also rolls **1–2 modifiers**, e.g.: *Windy* (stronger gusts), *Full moon* (double tips), *Short rations* (one fewer ingredient slot), *Health inspector* (burnt serves cost a heart), *Rain* (fire health drains).

### 9.2 Night events (random, telegraphed at dusk)
| Event | Effect |
|---|---|
| Food critic visits | One ultra-picky order; huge tip + bonus heart on success |
| Ingredient shortage | One random ingredient unavailable all night |
| Tour bus | Double campers, double pay, half patience |
| Marshmallow aurora (rare) | All mallows roast 25% slower — free perfection night |
| Grease fire | Random flare-ups all night (Desert synergy) |

### 9.3 Difficulty scaling
Night number scales: order complexity (more layers, fussier doneness), camper impatience, event intensity. Night 5 festival is a gauntlet — victory earns the **Golden Spatula** and a tour score (coins + accuracy + hearts remaining) for the leaderboard.

### 9.4 Why roguelike fits
The fantasy is "can you handle *tonight's* fire?" — not "did you memorize level 4." Procedural biomes + modifiers + draft builds make adaptability the skill, give streamers endless "one more tour" content, and make the Daily Roast (seeded tour, §10) a natural retention engine.

## 10. Game Modes

- **Tour Mode** — the roguelike core (§9). The game.
- **Daily Roast** — a seeded tour, identical for every player each day, with a global leaderboard. The retention engine and streamer bait.
- **Endless Shift** — unlocked after your first tour victory. One fire, escalating orders, leaderboard.
- **Cozy Sandbox** — no timers, no hearts, no fail, free ingredients. The "vibe" mode; surprisingly popular in playtests of similar games.

## 11. Steamworks Integration

- **Achievements (~30):** roast tiers ("Golden God": 100 golden serves), customers, secrets ("Burnt Offering": serve 10 burnt in one day).
- **Cloud saves.**
- **Leaderboards:** Tour scores, Endless, and Daily Roast.
- **Stats:** track for achievements and future balancing.
- Post-launch consideration: trading cards, Steam Workshop (custom recipes/campsites).

## 12. Art Direction: hand-crafted cozy, never AI

**The backdrops are the selling point.** Each biome is a recognizable American national park, painted as a layered parallax pixel-art vista. Players should screenshot them unprompted. Steam capsule art, the trailer, and the screenshots lead with the parks — not the UI.

### 12.1 The parks
1. **Yosemite** — granite cliff faces, waterfall with animated foam, ponderosa pines, golden-hour light.
2. **Joshua Tree** — twisted Joshua trees, cholla silhouettes, Milky Way wheeling overhead, distant coyote call.
3. **Sequoia** — cathedral sequoia trunks, drifting ground fog, ferns, dappled light shafts.
4. **Zion** — sheer sandstone walls, cottonwoods, the Virgin River glinting below.
5. **Bryce Canyon** — hoodoo amphitheater cycling sunrise hues, bristlecone pines, a circling raven.
6. **Arches** — Delicate Arch on the skyline, slickrock fins, desert varnish streaks, heat shimmer.
7. **Isle Royale** — Lake Superior shoreline, loons on the water, moose wading the shallows at dusk, a wolf pack crossing the far ridgeline, northern lights on rare clear nights.

Each park gets 3–4 parallax layers, 1–2 ambient wildlife species, one signature animated element, and its own dusk/night lighting treatment. Compositions are referenced from public-domain National Park Service photography — real places, real compositions.

### 12.2 The anti-AI style guide (non-negotiable)
AI-generated art has tells: muddy over-blended gradients, detail soup with no resting areas, inconsistent light, waxy symmetry. Our rules:
- **Limited deliberate palettes:** 16–32 colors per scene, chosen by hand. Flat shapes with hand-placed dithering — never smooth gradients.
- **One light source:** the campfire. Every highlight and shadow answers to it; flicker is hand-animated, never faked with blur.
- **Readable silhouettes:** every tree, tent, and animal reads as a shape at thumbnail size. No noise-for-detail.
- **Hand imperfection:** slightly wonky lines, asymmetric compositions, charming irregularity. If it looks too perfect, it's wrong.
- **Hand animation only:** 4–8 frame loops for fire, water, geysers, animals. Coherent pixel animation is something AI cannot do — it's our signature.
- **Tile discipline:** backgrounds built from hand-made tiles with deliberate variation, not stamped repetition.
- **Reference reality:** compose from NPS photos and real park visits, never from prompts.

### 12.3 Cozy amplifiers (the details that sell it)
- Foreground framing: grass tufts, tent guy-lines, a lantern swaying in the wind.
- Ambient life: fireflies, moths around the lantern, a fox that occasionally crosses the background, an owl call.
- Micro-storytelling: a cooler covered in park stickers, a dog asleep by the fire, the marshmallow bag on the prep table.
- Weather as mood: Yosemite mist, Acadia sea spray, canyon dust devils, Yellowstone snowfall.
- The fire is a character: it flares when you serve a golden, sulks when a camper storms out.
- Characters: readable silhouettes + one accessory (beanie, ranger hat) — orders shown as icon bubbles.

### 12.4 Juice & feel
Screen shake on flare-ups, ember particles, squash-and-stretch mallows, gooey chocolate stretch on serve. Dynamic fire lighting: the whole scene breathes with the flames.

### 12.5 Production
- Contract one human pixel artist; paid art test (one park backdrop + fire animation) before committing.
- Style guide with do/don't examples derived from §12.2.
- Per-park milestone: sketch → palette → parallax layers → animation pass → lighting pass.

## 13. Audio

- Procedural fire crackle (pitch/volume tied to fire size).
- Lo-fi acoustic guitar soundtrack, per-campsite variations.
- Satisfying feedback: *pop* on golden, sizzle on scorch, cha-ching on tips.
- Accessibility: visual equivalents for all audio cues; full mute + separate sliders.

## 14. UI/UX

- Diegetic where possible: roast meter as a thermometer staked by the fire; orders as pinned tickets on a board.
- One-screen kitchen: fire left, assembly right, customers top — no scrolling, no tabs mid-shift.
- Full controller support + mouse; touch for Steam Deck (verified target).
- **Mobile-first touch:** the entire game is one-finger playable — drag to move the stick, tap buttons and draft cards. No hover-dependent mechanics, no tiny targets (44px minimum). Landscape orientation; UI scales from phones to desktop.
- Colorblind-safe palettes; dyslexia-friendly font option; remappable keys.

## 15. Tech Stack

- **Engine:** Godot 4 (GDScript). Free, best-in-class 2D/pixel-art pipeline, exports to Windows/Mac/Linux from one project.
- **Steamworks:** GodotSteam plugin (achievements, leaderboards, cloud, stats).
- **Source control:** GitHub (this repo) — `main` (stable), `dev` branch, feature branches.
- **Web prototype** (`index.html`, already shipped) stays as the public demo/teaser and mechanics testbed.
- **Steam Deck:** Verified target — 1280×800, controller-first UI checks each milestone.
- **Android:** Godot exports to Android from the same codebase (export templates + Gradle build). Google Play Games Services plugin for achievement/leaderboard parity with Steamworks. Play Billing library if we ship the free-trial model (§18). Test on 3–4 real devices including a low-end one; pixel art keeps perf and battery cost trivial.

## 16. Scope Control (MVP definition)

**MVP (vertical slice, itch.io playtest):** full tour loop — 3-park pool (Yosemite, Zion, Isle Royale), 5-night tours, 12-card draft pool, night events, hearts/reputation, 8 recipes, meta-unlock skeleton. Prove "one more tour" in playtesting before building the rest.
**Not in MVP:** Daily Roast backend, Workshop, trading cards, voice acting, ports beyond PC.

## 17. Roadmap

| Phase | Duration | Deliverable |
|---|---|---|
| 0 — Pre-production | 2 weeks | Lock this GDD; paper-prototype order pacing; commission/define art style |
| 1 — Vertical slice | 6 weeks | MVP playable: 1 campsite, full loop, placeholder art |
| 2 — Content | 8 weeks | All 5 campsites, 24 recipes, 4 mallow types, customers, shop |
| 3 — Polish & Steamworks | 6 weeks | Final art/audio pass, achievements, leaderboards, cloud saves, Deck verified |
| 4 — Demo & launch prep | 4 weeks | Public demo (Steam Next Fest target), Steam page, trailer, press kit |
| Launch | — | Same-day Steam + Google Play. $7.99 Steam (10% launch discount) / Android free-trial + $4.99 unlock (see §18) |
| Post-launch | ongoing | Daily Roast support, bug fixes, evaluate Workshop. **Park Packs:** 3–4 new national parks per free update on the road to all 63 — each pack a marketing beat |

Total: ~6 months solo/small-team to launch.

## 18. Budget (solo/small team)

- Steam Direct fee: $100 (recoupable).
- Google Play Console: $25 one-time fee.
- **Android monetization (recommendation):** free download with Night 1 playable; a single in-app purchase ($4.99) unlocks the full tour. Cold premium is a brutal sell on mobile — a free trial turns every install into a demo. Fallback: straight $4.99 premium (simpler, no billing code, far fewer installs). Steam stays premium $7.99 with no IAP.
- Asset/audio tools & licenses: ~$500–2,000 (or rev-share with a pixel artist/composer).
- Optional: freelance pixel artist for character/campsite art if art isn't your strength — highest-ROI spend.
- Marketing: $0–500 (festivals and organic short-form video do the heavy lifting).

## 19. Marketing & Launch Plan

1. **Now:** keep the web prototype live — it's a playable teaser to link everywhere.
2. **Devlog:** bi-weekly; short-form video (TikTok/Shorts/Reels) of satisfying golden roasts — this genre clips *extremely* well.
3. **Steam page:** publish at start of Phase 3 with capsule art + trailer; goal 7,000–10,000 wishlists pre-launch (rule of thumb for a viable small launch).
4. **Demo:** Steam Next Fest; target 10%+ demo→wishlist conversion.
5. **Launch:** cozy-game press, Reddit (r/cozygames, r/pixelart), streamers who play chill games.
6. **Post-launch:** Daily Roast gives streamers a reason to return; update cadence monthly for 3 months.
7. **Android:** same-day Google Play launch; pitch mobile cozy-game press and YouTubers; the free trial *is* the marketing — short sessions and one-finger play are exactly what mobile players want.
8. **Backdrops are the marketing:** capsule art, trailer, and screenshots lead with the parks, never UI. Release the five park vistas as wallpapers at launch. Cozy players buy on vibe — hand them the vibe.

## 20. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Scope creep | MVP lock in §16; any new feature must replace something or wait for DLC |
| Art quality (if not an artist) | Hire/freelance one character artist; keep scope to readable silhouettes |
| Discoverability | Demo + Next Fest + short-form video; cozy games have strong communities |
| "One-note" gameplay fatigue | Environmental twists per campsite (§5.4) + Daily Roast variety |
| Burnout (solo dev) | 6-month cap; cut campsite 5 into DLC if needed rather than crunch |
| Android fragmentation & Play review | Test on real low-end devices; submit to Play review 2 weeks early; keep billing/IAP code isolated behind a platform flag so Steam builds stay clean |

## 21. Success Metrics

- **Wishlist velocity:** 7k–10k at launch.
- **Demo conversion:** ≥10% demo players wishlist.
- **Review score:** ≥85% positive (cozy audiences review generously when the vibe lands).
- **Roguelike health:** ≥40% tour completion rate eventually (too low = too brutal, too high = no tension); median 3+ tours per player in week one ("one more tour" working).
- **Android:** ≥4.2★ Play Store rating; trial→purchase conversion ≥5%; Android revenue treated as bonus on top of Steam, not the plan's foundation.
- **Year-1 revenue target:** $30k–80k at $7.99 (typical range for a well-executed small cozy title) — enough to fund the Park Packs or next game.

---

*This is a living document. Update it when playtesting contradicts it — the prototype is always right.*
