class_name Tuning
extends RefCounted
## Single source of truth for all game data and balance numbers.
## Mirrors the web prototype's TUNING / TARGETS / PARKS / CHOCS / CARDS / EVENTS
## exactly. All coordinates are in the 512x384 logical space (2x the web
## prototype's 256x192), so positional constants are the prototype's x2.

# Logical resolution.
const LOGICAL_W := 512
const LOGICAL_H := 384

# Fire layout (prototype: BASE_FIRE_X=80, fireY=150, box +/-22, zone height 46).
const FIRE_X := 160.0
const FIRE_Y := 300.0
const FIRE_HALF_W := 44.0
const FIRE_ZONE_H := 92.0
const FIRE_TOP_PAD := 8.0

# Stick tip movement.
const TIP_MIN := 8.0
const TIP_MAX_X := 504.0
const TIP_MAX_Y := 376.0
const TIP_SPEED := 280.0  # prototype 140 px/s at 256x192

# --- Balance (mirrors prototype TUNING exactly) ---
const NIGHTS := 5
const NIGHT_LENGTH := 90.0
const SPAWN_EVERY := 6.5
const FESTIVAL_SPAWN := 4.0
const MAX_WAITING := 3
const PATIENCE := 30.0
const HEAT_RATE := 0.28

const TARGETS := {
	"soft": {"label": "soft", "c": 0.23, "w": 0.12},
	"golden": {"label": "GOLDEN", "c": 0.52, "w": 0.17},
	"dark": {"label": "dark", "c": 0.80, "w": 0.10},
}

const PARKS := {
	"yosemite": {"name": "Yosemite", "effect": "calm"},
	"joshua": {"name": "Joshua Tree", "effect": "darkmallow"},
	"sequoia": {"name": "Sequoia", "effect": "damp"},
	"zion": {"name": "Zion", "effect": "wind"},
	"bryce": {"name": "Bryce Canyon", "effect": "swings"},
	"arches": {"name": "Arches", "effect": "heat"},
	"isle": {"name": "Isle Royale", "effect": "rain"},
}
## One-line mechanical twist per park, announced at night start.
const PARK_TIPS := {
	"yosemite": "calm night",
	"joshua": "trust the meter",
	"sequoia": "slow roast, chill campers",
	"zion": "watch for gusts",
	"bryce": "roast speed swings",
	"arches": "hot & fast",
	"isle": "storms coming",
}

# plate/dot are HTML hex strings (no '#'); converted with Color(html) at draw time.
const CHOCS := {
	"milk": {"name": "Milk", "plate": "4a2410", "dot": "a06a35"},
	"dark": {"name": "Dark", "plate": "241105", "dot": "6e3a15"},
	"reeses": {"name": "Reese's", "plate": "c96a1e", "dot": "ff9d2e"},
	"white": {"name": "White", "plate": "efe3c8", "dot": "fff7d6"},
	"caramel": {"name": "Caramel", "plate": "a34d12", "dot": "ffb347"},
}

const CAMPER_COLORS := ["c94f4f", "4f7dc9", "4fc94f", "c9a24f", "9a4fc9"]

# Draft cards. "effect" is an id handled by GameState.apply_card (const dicts
# cannot hold lambdas, so the prototype's apply closures live there instead).
const CARDS := [
	{"name": "Double-Prong Fork", "desc": "Roast 2 mallows at once. Stacking swaps the loaded one.", "once": true, "effect": "fork"},
	{"name": "Jumbo Mallows", "desc": "Roast 40% slower, +50% tips", "once": true, "effect": "jumbo"},
	{"name": "Daredevil", "desc": "+100% tips when serving mid flare-up", "once": true, "effect": "daredevil"},
	{"name": "Hot Streak", "desc": "Consecutive PERFECTs: +25% tips each. Resets on imperfect.", "once": true, "effect": "streak"},
	{"name": "Insulated Glove", "desc": "Doneness windows +30%", "effect": "glove"},
	{"name": "Sugar Rush", "desc": "Roast 25% faster", "effect": "sugarrush"},
	{"name": "Patient Crowd", "desc": "Campers 30% more patient", "effect": "patient"},
	{"name": "Campfire Songs", "desc": "Campers arrive 20% slower", "effect": "songs"},
	{"name": "Extra Heart", "desc": "+1 reputation heart", "effect": "heart"},
	{"name": "Reese's Cups", "desc": "Stock Reese's. +15% tips", "once": true, "effect": "reeses"},
	{"name": "Dark Chocolate", "desc": "Stock dark chocolate. +10% tips, +10% patience", "once": true, "effect": "darkchoc"},
	{"name": "White Chocolate", "desc": "Stock white chocolate. PERFECTs +40%", "once": true, "requires": "white", "effect": "whitechoc"},
	{"name": "Caramel Cups", "desc": "Stock caramel. Roast 10% slower, +30% tips", "once": true, "requires": "caramel", "effect": "caramel"},
	{"name": "Windbreaker", "desc": "Park effects halved", "effect": "windbreaker"},
	{"name": "Tarp", "desc": "Rain can't slow your roast", "effect": "tarp"},
	{"name": "Lucky Lighter", "desc": "First serve each night +25 coins", "effect": "lighter"},
]

const EVENTS := [
	{"name": "Food Critic", "desc": "PERFECTs pay double. Imperfect serves earn 0.", "effect": "critic"},
	{"name": "Storm Front", "desc": "Rain all night (slow roast), campers +50% patience", "effect": "storm"},
	{"name": "Bus Tour", "desc": "Campers arrive 40% faster, +25% tips", "effect": "bus"},
	{"name": "Quiet Night", "desc": "Campers arrive 40% slower, PERFECTs +50%", "effect": "quiet"},
]
