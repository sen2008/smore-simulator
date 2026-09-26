# Smore Simulator — Full Game Design Document

**Version:** 1.0 (2026-09-25)
**Status:** Pre-production
**Repo:** github.com/sen2008/smore-simulator

---

## 1. High Concept

*"Overcooked meets Stardew Valley at a campfire."*

You run a s'mores stand traveling through America's national parks. Campers line up with specific orders; you roast marshmallows over a living pixel fire to their exact liking, stack them with premium ingredients, and serve them up for coins and tips. Master the flame, upgrade your gear, and earn 3 stars at every campsite.

**One-sentence pitch:** A cozy-but-skill-based cooking game about achieving the perfect marshmallow roast.

## 2. Design Pillars

1. **The roast is the skill.** Fire mastery — not recipe memorization — is the core skill expression. Positioning, timing, and reading the flames separate good players from great ones.
2. **Cozy, never punishing.** Mistakes cost tips, not runs. No lives, no game-over shame spirals. The vibe is a warm campfire, even when it's hectic.
3. **Every campsite changes the rules.** New locations introduce new environmental twists so the core loop stays fresh across the whole campaign.

## 3. Target Audience & Positioning

- **Primary:** Cozy game players (Stardew, Unpacking, A Short Hike fans), 18–35, PC.
- **Secondary:** Score-chasers and speedrunners drawn to the mastery ceiling; parents/kids (E for Everyone tone).
- **Comps:** *Overcooked* (chaotic cooking), *Diner Dash* (order management), *Stardew Valley* (cozy progression).
- **Differentiator:** No cooking game has made fire itself the main mechanic. The roast meter is the hook; everything else supports it.

## 4. Core Loop

```
Campers arrive with orders → Roast mallow(s) to spec → Assemble stack
→ Serve → Earn coins + tips → Buy upgrades/ingredients → Unlock next campsite
```

A "day" is one shift: serve a set number of campers (or survive a timer in endless). Between days: shop, upgrade, review recipe book.

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

## 8. Economy & Progression

- **Coins:** base pay per serve + tip (accuracy × speed × customer generosity).
- **Stars:** each campsite rated 1–3 stars on earnings + accuracy; 2+ stars unlocks the next site.
- **Shop (between days):** tools, ingredients, cosmetic stand skins, fire pit upgrades (bigger sweet spot).
- **No grind wall:** a skilled player can 3-star with base gear; upgrades widen margin for error and enable new strategies.

## 9. Campsites (campaign structure, ~8–10 hours)

1. **Pinewood Forest** — tutorial. Calm fire, simple orders. Learn the zones.
2. **Lakeshore** — wind gusts introduced. Jumbo mallows.
3. **Desert Mesa** — intense heat (faster everything), flare-ups. Minis.
4. **Snowy Peaks** — fire health/stoking mechanic. Stuffed mallows. Night-only aesthetic.
5. **Festival Grounds** — finale: rush crowds, all mechanics, critic visits. Endless unlock.

Each site: 6 days, day 6 = "rush day" finale. 3-star all sites → Golden Spatula trophy + sandbox skins.

## 10. Game Modes

- **Campaign** (above) — the main game.
- **Endless Shift** — one fire, escalating orders, global leaderboard.
- **Cozy Sandbox** — no timers, no fail, free ingredients. The "vibe" mode; surprisingly popular in playtests of similar games.
- **Daily Roast** — seeded day (same orders for everyone), daily leaderboard. Retention engine.

## 11. Steamworks Integration

- **Achievements (~30):** roast tiers ("Golden God": 100 golden serves), customers, secrets ("Burnt Offering": serve 10 burnt in one day).
- **Cloud saves.**
- **Leaderboards:** Endless + Daily Roast.
- **Stats:** track for achievements and future balancing.
- Post-launch consideration: trading cards, Steam Workshop (custom recipes/campsites).

## 12. Art Direction

- 16-bit pixel art, warm palette (ambers, deep blues for night).
- Dynamic fire lighting: the whole scene breathes with the flames.
- Day/night cycle per shift; weather per campsite.
- Characters: readable silhouettes + one accessory (beanie, ranger hat) — orders shown as icon bubbles.
- Juice: screen shake on flare-ups, ember particles, squash-and-stretch mallows, gooey cheese-pull-style chocolate stretch on serve.

## 13. Audio

- Procedural fire crackle (pitch/volume tied to fire size).
- Lo-fi acoustic guitar soundtrack, per-campsite variations.
- Satisfying feedback: *pop* on golden, sizzle on scorch, cha-ching on tips.
- Accessibility: visual equivalents for all audio cues; full mute + separate sliders.

## 14. UI/UX

- Diegetic where possible: roast meter as a thermometer staked by the fire; orders as pinned tickets on a board.
- One-screen kitchen: fire left, assembly right, customers top — no scrolling, no tabs mid-shift.
- Full controller support + mouse; touch for Steam Deck (verified target).
- Colorblind-safe palettes; dyslexia-friendly font option; remappable keys.

## 15. Tech Stack

- **Engine:** Godot 4 (GDScript). Free, best-in-class 2D/pixel-art pipeline, exports to Windows/Mac/Linux from one project.
- **Steamworks:** GodotSteam plugin (achievements, leaderboards, cloud, stats).
- **Source control:** GitHub (this repo) — `main` (stable), `dev` branch, feature branches.
- **Web prototype** (`index.html`, already shipped) stays as the public demo/teaser and mechanics testbed.
- **Steam Deck:** Verified target — 1280×800, controller-first UI checks each milestone.

## 16. Scope Control (MVP definition)

**MVP (vertical slice, itch.io playtest):** 1 campsite, order system, 3 mallow types, 8 recipes, tier-1 upgrades, campaign day loop, no meta systems.
**Not in MVP:** multiplayer, workshop, trading cards, voice acting, ports beyond PC.

## 17. Roadmap

| Phase | Duration | Deliverable |
|---|---|---|
| 0 — Pre-production | 2 weeks | Lock this GDD; paper-prototype order pacing; commission/define art style |
| 1 — Vertical slice | 6 weeks | MVP playable: 1 campsite, full loop, placeholder art |
| 2 — Content | 8 weeks | All 5 campsites, 24 recipes, 4 mallow types, customers, shop |
| 3 — Polish & Steamworks | 6 weeks | Final art/audio pass, achievements, leaderboards, cloud saves, Deck verified |
| 4 — Demo & launch prep | 4 weeks | Public demo (Steam Next Fest target), Steam page, trailer, press kit |
| Launch | — | $7.99 launch price (10% launch discount) |
| Post-launch | ongoing | Daily Roast support, bug fixes, evaluate Workshop + DLC campsite pack |

Total: ~6 months solo/small-team to launch.

## 18. Budget (solo/small team)

- Steam Direct fee: $100 (recoupable).
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

## 20. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Scope creep | MVP lock in §16; any new feature must replace something or wait for DLC |
| Art quality (if not an artist) | Hire/freelance one character artist; keep scope to readable silhouettes |
| Discoverability | Demo + Next Fest + short-form video; cozy games have strong communities |
| "One-note" gameplay fatigue | Environmental twists per campsite (§5.4) + Daily Roast variety |
| Burnout (solo dev) | 6-month cap; cut campsite 5 into DLC if needed rather than crunch |

## 21. Success Metrics

- **Wishlist velocity:** 7k–10k at launch.
- **Demo conversion:** ≥10% demo players wishlist.
- **Review score:** ≥85% positive (cozy audiences review generously when the vibe lands).
- **Year-1 revenue target:** $30k–80k at $7.99 (typical range for a well-executed small cozy title) — enough to fund the DLC pack or next game.

---

*This is a living document. Update it when playtesting contradicts it — the prototype is always right.*
