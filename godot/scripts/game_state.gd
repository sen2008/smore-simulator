class_name GameState
extends RefCounted
## Pure game logic for Smore Simulator. No nodes, no drawing, no input.
## Faithful port of the web prototype (game.js): same numbers, same order of
## operations in scoring, same state machine. main.gd owns rendering + input
## and drives this via start_tour()/update()/serve()/etc., listening to signals.
##
## A SaveData must be assigned to `save` before start_tour().

signal night_ended
signal tour_won(new_unlock: bool)
signal tour_lost
signal heart_lost(hearts: int)
signal served(points: int, text: String)
signal message(text: String)

var save: SaveData

var screen: String = "title"  # title | night | draft | event | over | win
var tip := Vector2(300, 120)
var roast := 0.0        # loaded mallow: the one you'll stack
var roast_b := 0.0      # benched mallow: only meaningful with Double-Prong Fork
var layers: Array = []  # of String: graham/chocolate/mallow/graham

var tour: Dictionary = {}


func _new_mods() -> Dictionary:
	return {
		"rate": 1.0, "win": 0.0, "pat": 1.0, "tips": 1.0, "spawn": 1.0,
		"flat": 0, "night": 0.0, "resist": 1.0, "tarp": false, "first_bonus": 0,
		"fork": false, "daredevil": false, "streak": false, "owned": {},
	}


# ---------------- tour flow ----------------

func start_tour() -> void:
	tour = {
		"night": 0, "hearts": 3, "coins": 0, "mods": _new_mods(),
		"park_pool": [], "park": "", "time_left": 0.0, "campers": [],
		"spawn_t": 0.0, "served_this_night": 0, "rain_t": 8.0, "raining": false,
		"wind_t": 0.0, "flare_cd": 9.0, "flare_warn": 0.0, "flare": 0.0, "zone": "",
		"streak": 0, "event": {}, "critic": false, "ev_rain": false,
		"ev_spawn": 1.0, "ev_pat": 1.0, "ev_tips": 1.0, "ev_perfect": 1.0,
		"choc": "milk", "trending": "milk",
	}
	roast_b = 0.0
	start_night()


func _draw_park() -> String:
	var pool: Array = tour["park_pool"]
	if pool.is_empty():
		pool = Tuning.PARKS.keys()
		tour["park_pool"] = pool
	var i := randi_range(0, pool.size() - 1)
	var key := String(pool[i])
	pool.remove_at(i)
	return key


# Flare-ups escalate: cozy early, spicy late.
func flare_interval() -> float:
	return (9.0 + randf() * 7.0) * (1.0 - 0.07 * (float(tour["night"]) - 1.0))


func start_night() -> void:
	tour["night"] = int(tour["night"]) + 1
	tour["park"] = _draw_park()
	var mods: Dictionary = tour["mods"]
	tour["time_left"] = Tuning.NIGHT_LENGTH + float(mods["night"])
	tour["campers"] = []
	tour["spawn_t"] = 1.5
	tour["served_this_night"] = 0
	tour["rain_t"] = 8.0
	tour["raining"] = false
	tour["flare_cd"] = 5.0 + randf() * 3.0
	tour["flare_warn"] = 0.0
	tour["flare"] = 0.0
	tour["zone"] = ""
	tour["streak"] = 0
	tour["critic"] = false
	tour["ev_rain"] = false
	tour["ev_spawn"] = 1.0
	tour["ev_pat"] = 1.0
	tour["ev_tips"] = 1.0
	tour["ev_perfect"] = 1.0
	if not (tour["event"] as Dictionary).is_empty():
		apply_event(tour["event"])
		tour["event"] = {}
	var pool := choc_pool()
	tour["trending"] = String(pool[randi_range(0, pool.size() - 1)])
	if bool(tour["ev_rain"]):
		tour["raining"] = true
	layers = []
	roast = 0.0
	roast_b = 0.0
	screen = "night"
	emit_signal("message", String(Tuning.PARKS[String(tour["park"])]["name"])
		+ " — Night " + str(tour["night"]) + " of " + str(Tuning.NIGHTS))


func end_night() -> void:
	save.stamp_park(String(tour["park"]))
	if not save.is_unlocked("caramel") and save.passport.size() >= 3:
		if save.unlock("caramel"):
			emit_signal("message", "NEW INGREDIENT UNLOCKED: Caramel Cups!")
	if int(tour["night"]) >= Tuning.NIGHTS:
		_win_tour()
		return
	screen = "draft"
	emit_signal("night_ended")


func _win_tour() -> void:
	screen = "win"
	var new_unlock := save.unlock("white")
	save.record_win(int(tour["coins"]))
	emit_signal("tour_won", new_unlock)


func _game_over() -> void:
	screen = "over"
	save.record_best(int(tour["coins"]))
	emit_signal("tour_lost")


# ---------------- draft & events ----------------

func offer_draft() -> Array:
	var pool: Array = []
	for c in Tuning.CARDS:
		var card: Dictionary = c
		if bool(card.get("once", false)) and (tour["mods"] as Dictionary)["owned"].has(String(card["name"])):
			continue
		if card.has("requires") and not save.is_unlocked(String(card["requires"])):
			continue
		pool.append(card)
	var picks: Array = []
	for i in range(3):
		if pool.is_empty():
			break
		picks.append(pool.pop_at(randi_range(0, pool.size() - 1)))
	return picks


func apply_card(card: Dictionary) -> void:
	var mods: Dictionary = tour["mods"]
	match String(card["effect"]):
		"fork":
			mods["fork"] = true
		"jumbo":
			mods["rate"] = float(mods["rate"]) * 0.6
			mods["tips"] = float(mods["tips"]) * 1.5
		"daredevil":
			mods["daredevil"] = true
		"streak":
			mods["streak"] = true
		"glove":
			mods["win"] = float(mods["win"]) + 0.30
		"sugarrush":
			mods["rate"] = float(mods["rate"]) * 1.25
		"patient":
			mods["pat"] = float(mods["pat"]) * 1.30
		"songs":
			mods["spawn"] = float(mods["spawn"]) * 1.20
		"heart":
			tour["hearts"] = mini(5, int(tour["hearts"]) + 1)
		"reeses":
			tour["choc"] = "reeses"
			mods["tips"] = float(mods["tips"]) * 1.15
		"darkchoc":
			tour["choc"] = "dark"
			mods["tips"] = float(mods["tips"]) * 1.10
			mods["pat"] = float(mods["pat"]) * 1.10
		"whitechoc":
			tour["choc"] = "white"
		"caramel":
			tour["choc"] = "caramel"
			mods["rate"] = float(mods["rate"]) * 0.9
			mods["tips"] = float(mods["tips"]) * 1.3
		"windbreaker":
			mods["resist"] = 0.5
		"tarp":
			mods["tarp"] = true
		"lighter":
			mods["first_bonus"] = 25
	if bool(card.get("once", false)):
		(mods["owned"] as Dictionary)[String(card["name"])] = true


func offer_event() -> Array:
	var pool: Array = Tuning.EVENTS.duplicate()
	var picks: Array = []
	for i in range(2):
		if pool.is_empty():
			break
		picks.append(pool.pop_at(randi_range(0, pool.size() - 1)))
	return picks


func apply_event(ev: Dictionary) -> void:
	match String(ev["effect"]):
		"critic":
			tour["critic"] = true
		"storm":
			tour["ev_rain"] = true
			tour["ev_pat"] = 1.5
		"bus":
			tour["ev_spawn"] = 0.6
			tour["ev_tips"] = 1.25
		"quiet":
			tour["ev_spawn"] = 1.4
			tour["ev_perfect"] = 1.5


func choose_event(ev: Dictionary) -> void:
	tour["event"] = ev
	start_night()


func choc_pool() -> Array:
	var pool := ["milk", "dark", "reeses"]
	if save.is_unlocked("white"):
		pool.append("white")
	if save.is_unlocked("caramel"):
		pool.append("caramel")
	return pool


# ---------------- campers & serving ----------------

func spawn_camper() -> void:
	var r := randf()
	var key := "dark"
	if r < 0.5:
		key = "golden"
	elif r < 0.75:
		key = "soft"
	var cr := randf()
	var pool := choc_pool()
	var crave := ""
	if cr >= 0.5:
		crave = String(tour["trending"]) if randf() < 0.55 else String(pool[randi_range(0, pool.size() - 1)])
	var mods: Dictionary = tour["mods"]
	var p: float = Tuning.PATIENCE * float(mods["pat"]) * float(tour["ev_pat"])
	var cols: Array = Tuning.CAMPER_COLORS
	(tour["campers"] as Array).append({
		"key": key,
		"crave": crave,
		"patience": p,
		"max_patience": p,
		"color": String(cols[randi_range(0, cols.size() - 1)]),
		"bob": randf() * TAU,
	})


func expected_next() -> String:
	var order := ["graham", "chocolate", "mallow", "graham"]
	if layers.size() >= 4:
		return ""
	return String(order[layers.size()])


func add_layer(kind: String) -> bool:
	if screen != "night":
		return false
	var want := expected_next()
	if want == "":
		emit_signal("message", "S'more is done — SERVE it!")
		return false
	if kind != want:
		emit_signal("message", "Wrong order! Need: " + want)
		return false
	layers.append(kind)
	if layers.size() == 4:
		emit_signal("message", "Tap SERVE!")
	return true


func fresh() -> void:
	if screen != "night":
		return
	roast = 0.0
	emit_signal("message", "Fresh mallow!")


func serve() -> Dictionary:
	var result := {"points": 0, "text": "", "perfect": false}
	if screen != "night" or tour.is_empty():
		return result
	if layers.size() != 4:
		emit_signal("message", "Stack all 4 layers first!")
		return result
	var campers: Array = tour["campers"]
	if campers.is_empty():
		emit_signal("message", "No campers waiting!")
		return result
	var mods: Dictionary = tour["mods"]
	var camper: Dictionary = campers[0]
	var target: Dictionary = Tuning.TARGETS[String(camper["key"])]
	var w: float = float(target["w"]) * (1.0 + float(mods["win"]))
	var d: float = absf(roast - float(target["c"]))
	var festival := int(tour["night"]) == Tuning.NIGHTS
	var perfect := d <= w
	var pts := 0
	var msg := ""
	if perfect:
		pts = 100
		msg = "PERFECT " + String(target["label"]) + "!"
	elif d <= w * 2.0:
		pts = 50
		msg = "Good enough."
	else:
		pts = 15
		msg = "They wanted " + String(target["label"]) + "..."
	if bool(tour["critic"]) and not perfect:
		pts = 0
	if perfect:
		pts = int(round(float(pts) * (2.0 if bool(tour["critic"]) else 1.0) * float(tour["ev_perfect"])))
	if perfect and String(tour["choc"]) == "white":
		pts = int(round(float(pts) * 1.4))
	if festival:
		pts *= 2
	if String(camper["crave"]) != "" and String(camper["crave"]) == String(tour["choc"]):
		pts = int(round(float(pts) * 1.5))
		msg += " CRAVED!"
	if bool(mods["daredevil"]) and float(tour["flare"]) > 0.0:
		pts *= 2
		msg += " DAREDEVIL!"
	if bool(mods["streak"]):
		if perfect:
			tour["streak"] = int(tour["streak"]) + 1
			pts = int(round(float(pts) * (1.0 + 0.25 * float(tour["streak"]))))
			msg += " x" + str(tour["streak"])
		else:
			tour["streak"] = 0
	pts = int(round(float(pts) * float(mods["tips"]) * float(tour["ev_tips"]))) + int(mods["flat"])
	if int(tour["served_this_night"]) == 0:
		pts += int(mods["first_bonus"])
	tour["coins"] = int(tour["coins"]) + pts
	tour["served_this_night"] = int(tour["served_this_night"]) + 1
	campers.pop_front()
	layers = []
	if bool(mods["fork"]):
		roast = roast_b  # stacking swaps the loaded prong
		roast_b = 0.0
	else:
		roast = 0.0
	var text := msg + " +" + str(pts)
	emit_signal("served", pts, text)
	emit_signal("message", text)
	result["points"] = pts
	result["text"] = text
	result["perfect"] = perfect
	return result


# ---------------- fire & heat ----------------

func fire_x(now_msec: float) -> float:
	if screen == "night" and not tour.is_empty() \
			and String(Tuning.PARKS[String(tour["park"])]["effect"]) == "wind":
		return Tuning.FIRE_X + sin(now_msec / 900.0) * 40.0 * float((tour["mods"] as Dictionary)["resist"])
	return Tuning.FIRE_X


func _over_fire(fx: float) -> bool:
	return tip.x > fx - Tuning.FIRE_HALF_W and tip.x < fx + Tuning.FIRE_HALF_W \
		and tip.y > Tuning.FIRE_Y - Tuning.FIRE_ZONE_H and tip.y < Tuning.FIRE_Y + Tuning.FIRE_TOP_PAD


func zone_at(fx: float) -> Dictionary:
	if not _over_fire(fx):
		return {}
	var rel := (Tuning.FIRE_Y - tip.y) / Tuning.FIRE_ZONE_H  # 0 at base, 1 at flame tip
	var zone := "cool"
	var mult := 0.45
	if rel < 0.35:
		zone = "SCORCH"
		mult = 2.6
	elif rel < 0.70:
		zone = "SWEET"
		mult = 1.0
	if float(tour["flare"]) > 0.0:
		mult *= 2.0
	return {"zone": zone, "mult": mult}


# ---------------- per-frame ----------------

func update(dt: float, now_msec: float) -> void:
	dt = minf(dt, 0.05)
	if screen != "night" or tour.is_empty():
		return
	var mods: Dictionary = tour["mods"]
	tour["time_left"] = float(tour["time_left"]) - dt
	tour["wind_t"] = float(tour["wind_t"]) + dt

	# Rain (Isle Royale) — or all-night rain from Storm Front.
	if bool(tour["ev_rain"]):
		tour["raining"] = true
	elif String(Tuning.PARKS[String(tour["park"])]["effect"]) == "rain":
		tour["rain_t"] = float(tour["rain_t"]) - dt
		if float(tour["rain_t"]) <= 0.0:
			tour["raining"] = not bool(tour["raining"])
			tour["rain_t"] = 5.0 if bool(tour["raining"]) else 11.0
			if bool(tour["raining"]):
				emit_signal("message", "Lake storm! Shelter the fire!")

	# Spawn campers.
	tour["spawn_t"] = float(tour["spawn_t"]) - dt
	var festival := int(tour["night"]) == Tuning.NIGHTS
	var every: float = (Tuning.FESTIVAL_SPAWN if festival else Tuning.SPAWN_EVERY) \
		* float(mods["spawn"]) * float(tour["ev_spawn"])
	var campers: Array = tour["campers"]
	if float(tour["spawn_t"]) <= 0.0 and campers.size() < Tuning.MAX_WAITING:
		spawn_camper()
		tour["spawn_t"] = every

	# Patience / storm-outs.
	for i in range(campers.size() - 1, -1, -1):
		var c: Dictionary = campers[i]
		c["patience"] = float(c["patience"]) - dt
		c["bob"] = float(c["bob"]) + dt * 3.0
		if float(c["patience"]) <= 0.0:
			campers.remove_at(i)
			tour["hearts"] = int(tour["hearts"]) - 1
			emit_signal("heart_lost", int(tour["hearts"]))
			emit_signal("message", "A camper stormed out! Hearts: " + str(tour["hearts"]))
			if int(tour["hearts"]) <= 0:
				_game_over()

	# Flare-ups: telegraphed surge, then the whole fire doubles.
	if float(tour["flare"]) > 0.0:
		tour["flare"] = float(tour["flare"]) - dt
	elif float(tour["flare_warn"]) > 0.0:
		tour["flare_warn"] = float(tour["flare_warn"]) - dt
		if float(tour["flare_warn"]) <= 0.0:
			tour["flare"] = 2.2
			emit_signal("message", "FLARE-UP! Pull out!")
	else:
		tour["flare_cd"] = float(tour["flare_cd"]) - dt
		if float(tour["flare_cd"]) <= 0.0:
			tour["flare_warn"] = 1.2
			tour["flare_cd"] = flare_interval()
			emit_signal("message", "The fire is surging...")

	# Roast — heat zones make positioning the skill.
	var z := zone_at(fire_x(now_msec))
	if not z.is_empty():
		var rate: float = Tuning.HEAT_RATE * float(mods["rate"]) * float(z["mult"])
		if bool(tour["raining"]):
			rate *= 1.0 if bool(mods["tarp"]) else (0.35 + 0.3 * (1.0 - float(mods["resist"])))
		roast = minf(1.0, roast + dt * rate)
		if bool(mods["fork"]):
			roast_b = minf(1.0, roast_b + dt * rate)
	tour["zone"] = String(z.get("zone", ""))

	if float(tour["time_left"]) <= 0.0:
		tour["time_left"] = 0.0
		end_night()
