extends Node2D
## Smore Simulator — presentation layer.
## Owns a GameState (pure logic) and renders it in the 512x384 logical space
## with chunky pixel rects. Handles mouse drag + touch + keyboard input and
## wires the overlay panels (title / draft / event / game-over / win).

var state: GameState
var save: SaveData

var particles: Array = []  # {x, y, vy, life, c (hex), rain (bool)}
var stars: Array = []      # {x, y, tw}
var msg_text := ""
var msg_t := 0.0
var flash_t := 0.0
var time_msec := 0.0

var draft_picks: Array = []
var event_picks: Array = []

@onready var btn_graham: Button = $UI/TouchButtons/BtnGraham
@onready var btn_choc: Button = $UI/TouchButtons/BtnChoc
@onready var btn_mallow: Button = $UI/TouchButtons/BtnMallow
@onready var btn_serve: Button = $UI/TouchButtons/BtnServe
@onready var btn_fresh: Button = $UI/TouchButtons/BtnFresh

@onready var title_overlay: CenterContainer = $UI/TitleOverlay
@onready var title_info: Label = $UI/TitleOverlay/Panel/VBox/TitleInfo
@onready var title_stats: Label = $UI/TitleOverlay/Panel/VBox/TitleStats
@onready var title_passport: Label = $UI/TitleOverlay/Panel/VBox/TitlePassport
@onready var title_unlocks: Label = $UI/TitleOverlay/Panel/VBox/TitleUnlocks
@onready var btn_start: Button = $UI/TitleOverlay/Panel/VBox/BtnStart

@onready var draft_overlay: CenterContainer = $UI/DraftOverlay
@onready var draft_title: Label = $UI/DraftOverlay/Panel/VBox/DraftTitle
@onready var draft_info: Label = $UI/DraftOverlay/Panel/VBox/DraftInfo
@onready var draft_cards: VBoxContainer = $UI/DraftOverlay/Panel/VBox/DraftCards

@onready var event_overlay: CenterContainer = $UI/EventOverlay
@onready var event_title: Label = $UI/EventOverlay/Panel/VBox/EventTitle
@onready var event_cards: VBoxContainer = $UI/EventOverlay/Panel/VBox/EventCards

@onready var over_overlay: CenterContainer = $UI/OverOverlay
@onready var over_info: Label = $UI/OverOverlay/Panel/VBox/OverInfo
@onready var btn_again_over: Button = $UI/OverOverlay/Panel/VBox/BtnAgainOver

@onready var win_overlay: CenterContainer = $UI/WinOverlay
@onready var win_unlock: Label = $UI/WinOverlay/Panel/VBox/WinUnlock
@onready var win_passport: Label = $UI/WinOverlay/Panel/VBox/WinPassport
@onready var win_info: Label = $UI/WinOverlay/Panel/VBox/WinInfo
@onready var btn_again_win: Button = $UI/WinOverlay/Panel/VBox/BtnAgainWin


func _ready() -> void:
	randomize()
	save = SaveData.new()
	save.load_all()
	state = GameState.new()
	state.save = save
	state.night_ended.connect(_on_night_ended)
	state.tour_won.connect(_on_tour_won)
	state.tour_lost.connect(_on_tour_lost)
	state.heart_lost.connect(_on_heart_lost)
	state.served.connect(_on_served)
	state.message.connect(_on_message)

	for i in range(70):
		stars.append({"x": randf() * Tuning.LOGICAL_W, "y": randf() * 180.0, "tw": randf() * TAU})

	btn_graham.pressed.connect(func() -> void: state.add_layer("graham"))
	btn_choc.pressed.connect(func() -> void: state.add_layer("chocolate"))
	btn_mallow.pressed.connect(func() -> void: state.add_layer("mallow"))
	btn_serve.pressed.connect(func() -> void: state.serve())
	btn_fresh.pressed.connect(func() -> void: state.fresh())
	btn_start.pressed.connect(_begin_tour)
	btn_again_over.pressed.connect(_begin_tour)
	btn_again_win.pressed.connect(_begin_tour)

	_show_title()


func _begin_tour() -> void:
	_hide_overlays()
	state.start_tour()


# ---------------- UI ----------------

func _hide_overlays() -> void:
	title_overlay.hide()
	draft_overlay.hide()
	event_overlay.hide()
	over_overlay.hide()
	win_overlay.hide()


func _show_title() -> void:
	_hide_overlays()
	title_info.text = "A 5-night tour through the national parks.\nKeep your 3 hearts. Draft upgrades.\nBecome a Legendary Roastmaster."
	title_stats.text = "Best: %d    Tours won: %d" % [save.best, save.wins]
	title_passport.text = "Passport: " + _passport_names()
	title_unlocks.text = _unlock_line()
	title_overlay.show()


func _on_night_ended() -> void:
	if state.screen != "draft":
		return
	draft_picks = state.offer_draft()
	for c in draft_cards.get_children():
		c.queue_free()
	for i in draft_picks.size():
		var card: Dictionary = draft_picks[i]
		var b := Button.new()
		b.text = String(card["name"]) + "\n" + String(card["desc"])
		b.custom_minimum_size = Vector2(420, 72)
		b.pressed.connect(_on_card_chosen.bind(i))
		draft_cards.add_child(b)
	draft_title.text = "NIGHT %d COMPLETE" % int(state.tour["night"])
	draft_info.text = "%s survived. Choose an upgrade.\nHearts: %d    Coins: %d" % [
		String(Tuning.PARKS[String(state.tour["park"])]["name"]),
		int(state.tour["hearts"]), int(state.tour["coins"])]
	_hide_overlays()
	draft_overlay.show()


func _on_card_chosen(i: int) -> void:
	if i < 0 or i >= draft_picks.size():
		return
	state.apply_card(draft_picks[i])
	event_picks = state.offer_event()
	for c in event_cards.get_children():
		c.queue_free()
	for j in event_picks.size():
		var ev: Dictionary = event_picks[j]
		var b := Button.new()
		b.text = String(ev["name"]) + "\n" + String(ev["desc"])
		b.custom_minimum_size = Vector2(420, 72)
		b.pressed.connect(_on_event_chosen.bind(j))
		event_cards.add_child(b)
	event_title.text = "NIGHT %d APPROACHES — choose tonight's twist:" % (int(state.tour["night"]) + 1)
	_hide_overlays()
	event_overlay.show()


func _on_event_chosen(i: int) -> void:
	if i < 0 or i >= event_picks.size():
		return
	_hide_overlays()
	state.choose_event(event_picks[i])


func _on_tour_won(new_unlock: bool) -> void:
	win_info.text = "Coins: %d    Best: %d    Tours won: %d" % [int(state.tour["coins"]), save.best, save.wins]
	win_passport.text = "Passport: " + _passport_names()
	win_unlock.text = "NEW INGREDIENT UNLOCKED: White Chocolate!" if new_unlock else _unlock_line()
	_hide_overlays()
	win_overlay.show()


func _on_tour_lost() -> void:
	over_info.text = "Tour ended on night %d of %d at %s.\nCoins: %d    Best: %d" % [
		int(state.tour["night"]), Tuning.NIGHTS,
		String(Tuning.PARKS[String(state.tour["park"])]["name"]),
		int(state.tour["coins"]), save.best]
	_hide_overlays()
	over_overlay.show()


func _on_heart_lost(_hearts: int) -> void:
	flash_t = 0.6


func _on_served(_points: int, _text: String) -> void:
	pass  # the message signal already shows the result


func _on_message(t: String) -> void:
	msg_text = t
	msg_t = 2.5


func _passport_names() -> String:
	if save.passport.is_empty():
		return "empty"
	var names: Array = []
	for k in save.passport:
		var pk := String(k)
		names.append(String(Tuning.PARKS[pk]["name"]) if Tuning.PARKS.has(pk) else pk)
	return ", ".join(names)


func _unlock_line() -> String:
	var w := "White choc ✓" if save.is_unlocked("white") else "White choc: win a tour"
	var c := "Caramel ✓" if save.is_unlocked("caramel") else "Caramel: stamp %d more parks" % maxi(0, 3 - save.passport.size())
	return "Unlocks: " + w + " · " + c


# ---------------- input ----------------

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		if (mm.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
			_pointer_to_tip(mm.position)
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_pointer_to_tip(mb.position)
	elif event is InputEventScreenTouch:
		var st := event as InputEventScreenTouch
		if st.pressed:
			_pointer_to_tip(st.position)
	elif event is InputEventScreenDrag:
		_pointer_to_tip((event as InputEventScreenDrag).position)
	elif event is InputEventKey:
		var k := event as InputEventKey
		if k.pressed and not k.echo:
			_handle_key(k.keycode)


func _pointer_to_tip(screen_pos: Vector2) -> void:
	if state.screen != "night":
		return
	var p: Vector2 = get_canvas_transform().affine_inverse() * screen_pos
	if p.y > Tuning.LOGICAL_H - 76.0:
		return  # the touch button bar handles its own input
	state.tip.x = clampf(p.x, Tuning.TIP_MIN, Tuning.TIP_MAX_X)
	state.tip.y = clampf(p.y, Tuning.TIP_MIN, Tuning.TIP_MAX_Y)


func _handle_key(code: Key) -> void:
	match code:
		KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
			if state.screen == "title":
				_begin_tour()
		KEY_R:
			if state.screen == "over" or state.screen == "win":
				_begin_tour()
		KEY_G:
			state.add_layer("graham")
		KEY_C:
			state.add_layer("chocolate")
		KEY_M:
			state.add_layer("mallow")
		KEY_E:
			state.serve()
		KEY_N:
			state.fresh()


func _process(delta: float) -> void:
	time_msec = float(Time.get_ticks_msec())
	if state.screen == "night" and not state.tour.is_empty():
		var sp := Tuning.TIP_SPEED * delta
		if Input.is_key_pressed(KEY_LEFT):
			state.tip.x -= sp
		if Input.is_key_pressed(KEY_RIGHT):
			state.tip.x += sp
		if Input.is_key_pressed(KEY_UP):
			state.tip.y -= sp
		if Input.is_key_pressed(KEY_DOWN):
			state.tip.y += sp
		state.tip.x = clampf(state.tip.x, Tuning.TIP_MIN, Tuning.TIP_MAX_X)
		state.tip.y = clampf(state.tip.y, Tuning.TIP_MIN, Tuning.TIP_MAX_Y)
		state.update(delta, time_msec)
		_spawn_particles()
	if msg_t > 0.0:
		msg_t -= delta
	if flash_t > 0.0:
		flash_t -= delta
	for p in particles:
		var pd: Dictionary = p
		pd["y"] = float(pd["y"]) + float(pd["vy"]) * delta
		pd["life"] = float(pd["life"]) - delta
	particles = particles.filter(func(p) -> bool: return float(p["life"]) > 0.0)
	for s in stars:
		var sd: Dictionary = s
		sd["tw"] = float(sd["tw"]) + delta
	queue_redraw()


func _spawn_particles() -> void:
	var fx := state.fire_x(time_msec)
	if String(state.tour["zone"]) != "" and randf() < 0.5:
		particles.append({"x": state.tip.x + randf_range(-8.0, 8.0), "y": state.tip.y,
			"vy": randf_range(-80.0, -40.0), "life": 0.5, "c": "ff9d2e", "rain": false})
	if bool(state.tour["raining"]) and randf() < 0.6:
		particles.append({"x": randf() * Tuning.LOGICAL_W, "y": -8.0,
			"vy": 240.0, "life": 1.6, "c": "6fa8dc", "rain": true})
	var cols := ["ff3d00", "ff9d2e", "ffe14d"]
	for i in range(3):
		particles.append({"x": fx + randf_range(-28.0, 28.0), "y": Tuning.FIRE_Y - 8.0,
			"vy": randf_range(-160.0, -80.0), "life": randf_range(0.4, 0.8),
			"c": cols[randi_range(0, 2)], "rain": false})


# ---------------- drawing ----------------

func _px(x: float, y: float, w: float, h: float, c: Color) -> void:
	draw_rect(Rect2(x, y, w, h), c)


func _mallow_color(r: float) -> Color:
	var stops := [Color(1, 1, 1), Color(0.961, 0.784, 0.431), Color(0.541, 0.353, 0.169), Color(0.102, 0.102, 0.102)]
	var pos := [0.0, 0.5, 0.8, 1.0]
	var i := 0
	while i < pos.size() - 2 and r > pos[i + 1]:
		i += 1
	var t := clampf((r - pos[i]) / (pos[i + 1] - pos[i]), 0.0, 1.0)
	return stops[i].lerp(stops[i + 1], t)


func _draw() -> void:
	var park_key := "yosemite"
	if (state.screen == "night" or state.screen == "draft" or state.screen == "event") and not state.tour.is_empty():
		park_key = String(state.tour["park"])
	_draw_background(park_key)
	var fx := state.fire_x(time_msec)
	_draw_fire(fx)
	if state.screen == "night" and not state.tour.is_empty():
		_draw_campers()
		_draw_plate()
		_draw_stick()
		_draw_hud()
	elif not state.tour.is_empty() and (state.screen == "draft" or state.screen == "event"):
		_draw_hud()
	if flash_t > 0.0:
		draw_rect(Rect2(0, 0, Tuning.LOGICAL_W, Tuning.LOGICAL_H), Color(1, 0.16, 0.16, flash_t * 0.4))
	if msg_t > 0.0 and msg_text != "":
		var m := msg_text.left(34)
		var font := ThemeDB.fallback_font
		draw_rect(Rect2(36, 120, 440, 40), Color(0, 0, 0))
		draw_rect(Rect2(36, 120, 440, 40), Color(1, 0.7, 0.28), false, 2.0)
		var w := font.get_string_size(m, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x
		draw_string(font, Vector2(256 - w / 2.0, 146), m, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(1, 0.7, 0.28))


func _draw_background(park_key: String) -> void:
	_px(0, 0, Tuning.LOGICAL_W, Tuning.LOGICAL_H, Color("0b1020"))
	for s in stars:
		var sd: Dictionary = s
		var a := 0.4 + 0.6 * absf(sin(float(sd["tw"])))
		_px(float(sd["x"]), float(sd["y"]), 2, 2, Color(1, 1, 1, a))
	if park_key == "yosemite":
		_px(0, 40, 140, 240, Color("5a5a6e"))
		_px(16, 60, 108, 200, Color("6e6e80"))
		_px(60, 40, 20, 240, Color("9ad1ff"))  # waterfall
		for y in range(48, 280, 16):
			_px(62, y + fmod(time_msec / 200.0, 16.0), 16, 4, Color("d8f0ff"))
		_px(300, 120, 212, 160, Color("2a3a2a"))  # pine ridge
		for x in range(300, 512, 28):
			_px(x, 192, 16, 88, Color("1c2e1c"))
			_px(x - 6, 176, 28, 24, Color("2e5a2e"))
	elif park_key == "zion":
		_px(0, 60, 104, 224, Color("8a4a2a"))
		_px(12, 80, 80, 184, Color("a85e36"))
		_px(408, 60, 104, 224, Color("7a3e22"))
		_px(420, 80, 80, 184, Color("96522e"))
		_px(104, 256, 304, 24, Color("4a6a8a"))  # river glint
		for x in range(112, 400, 24):
			_px(x, 260 + fmod(time_msec / 300.0, 12.0), 16, 4, Color("9ad1ff"))
	elif park_key == "isle":
		_px(0, 200, Tuning.LOGICAL_W, 84, Color("123a5a"))  # lake superior
		for x in range(0, 512, 36):
			_px(x, 224 + fmod(time_msec / 400.0, 16.0), 24, 4, Color(0.604, 0.82, 1.0, 0.5))
		_px(300, 120, 212, 84, Color("1a2e22"))  # far ridgeline
		var mx := 392.0  # moose silhouette at dusk
		_px(mx, 184, 36, 20, Color("0a0f0a"))
		_px(mx + 24, 164, 12, 24, Color("0a0f0a"))
		_px(mx + 8, 204, 6, 16, Color("0a0f0a"))
		_px(mx + 22, 204, 6, 16, Color("0a0f0a"))
		_px(mx + 26, 156, 12, 4, Color("0a0f0a"))  # antlers
		for wx in [300.0, 326.0, 456.0]:  # wolf pack on the far ridgeline
			_px(wx, 128, 20, 10, Color("0a0f0a"))
			_px(wx + 14, 120, 8, 10, Color("0a0f0a"))
			_px(wx + 16, 112, 4, 8, Color("0a0f0a"))
			_px(wx + 4, 138, 4, 8, Color("0a0f0a"))
			_px(wx + 12, 138, 4, 8, Color("0a0f0a"))
	elif park_key == "joshua":
		for x in range(0, 512, 10):  # milky way band
			_px(x, 68 + sin(x / 56.0) * 18, 4, 4, Color(0.78, 0.8, 1.0, 0.28))
		for jx in [72.0, 416.0]:  # joshua trees
			_px(jx, 208, 12, 76, Color("3a2c1c"))
			_px(jx - 16, 192, 44, 10, Color("3a2c1c"))
			for sx in [jx - 18, jx - 4, jx + 12, jx + 24]:
				_px(sx, 176, 10, 16, Color("2e4a2e"))
				_px(sx + 2, 168, 6, 8, Color("3e5e3e"))
	elif park_key == "sequoia":
		for sx in [28.0, 192.0, 392.0]:  # towering trunks
			_px(sx, 0, 60, 284, Color("4a2418"))
			_px(sx + 10, 0, 14, 284, Color("5f3524"))
			_px(sx + 40, 0, 8, 284, Color("332015"))
		for x in range(0, 512, 32):  # ferns
			_px(x, 264, 20, 20, Color("1e3a24"))
		_px(0, 236, Tuning.LOGICAL_W, 48, Color(0.7, 0.78, 0.86, 0.07))  # ground fog
	elif park_key == "bryce":
		var bands := [Color("c96a3a"), Color("e09a5a"), Color("b85a30"), Color("d88a4a")]
		for h in [[20.0, 36.0, 192.0], [88.0, 28.0, 140.0], [300.0, 40.0, 208.0], [364.0, 28.0, 156.0], [428.0, 36.0, 180.0]]:
			var hx: float = h[0]; var hw: float = h[1]; var hh: float = h[2]
			for y in range(0, int(hh), 16):
				_px(hx + sin(y / 24.0) * 4, 284 - hh + y, hw, 16, bands[int(y / 16) % 4])
			_px(hx + 4, 284 - hh - 12, hw - 8, 12, bands[1])  # caprock
	elif park_key == "arches":
		_px(0, 32, Tuning.LOGICAL_W, 52, Color("2e1430"))
		_px(0, 84, Tuning.LOGICAL_W, 52, Color("5a2a24"))
		_px(0, 136, Tuning.LOGICAL_W, 52, Color("8a4a2a"))
		_px(120, 120, 28, 164, Color("a85e36"))
		_px(300, 120, 28, 164, Color("a85e36"))
		for x in range(120, 312, 12):  # delicate arch span
			var ay := 120 - sin((x - 120) / 180.0 * PI) * 52
			_px(x, ay, 12, 24, Color("c07a44"))
		_px(0, 256, Tuning.LOGICAL_W, 28, Color("6e3a22"))  # slickrock
	_px(436, 20, 28, 28, Color("e8e6c9"))  # moon
	var gcol := {"yosemite": "1c3a1c", "joshua": "4a3a22", "sequoia": "16281c", "zion": "3a2a1c",
		"bryce": "4a2a1c", "arches": "4a2418", "isle": "16302a"}
	_px(0, 284, Tuning.LOGICAL_W, 100, Color(String(gcol.get(park_key, "1c3a1c"))))
	_px(0, 284, Tuning.LOGICAL_W, 6, Color("6e5a34") if park_key == "joshua" else (Color("5a422a") if park_key == "zion" else Color("2e5a2e")))


func _draw_fire(fx: float) -> void:
	var stone_x := [-52.0, -36.0, -20.0, -4.0, 12.0, 28.0, 44.0]
	for i in stone_x.size():
		_px(fx + stone_x[i], 296 + (i % 2) * 2, 18, 12, Color("8a8a8a") if i % 2 == 0 else Color("6b6b6b"))
	_px(fx - 32, 280, 68, 12, Color("5a3a1a"))
	_px(fx - 28, 268, 60, 10, Color("6e4a22"))
	var t := time_msec / 120.0
	var boost := 1.0
	if state.screen == "night" and not state.tour.is_empty():
		if float(state.tour["flare"]) > 0.0:
			boost = 1.6
		elif float(state.tour["flare_warn"]) > 0.0:
			boost = 1.3
	var cols := ["ff3d00", "ff9d2e", "ffe14d", "fff7b0", "ffe14d"]
	for i in range(5):
		var h := (36.0 + sin(t + i * 1.7) * 14.0 + randf() * 8.0) * boost
		var wdt := 44.0 - i * 6.0
		_px(fx - wdt / 2.0, Tuning.FIRE_Y - 24 - h + i * 10, wdt, 12, Color(cols[i]))
	draw_circle(Vector2(fx, Tuning.FIRE_Y - 40), 92, Color(1, 0.55, 0.16, 0.08))
	for p in particles:
		var pd: Dictionary = p
		var a := clampf(float(pd["life"]) * 2.0, 0.0, 1.0)
		var pc := Color(String(pd["c"]))
		pc.a = a
		if bool(pd["rain"]):
			draw_line(Vector2(float(pd["x"]), float(pd["y"])),
				Vector2(float(pd["x"]) - 4, float(pd["y"]) + 12), pc, 2.0)
		else:
			_px(float(pd["x"]), float(pd["y"]), 4, 4, pc)


func _draw_campers() -> void:
	var campers: Array = state.tour["campers"]
	var font := ThemeDB.fallback_font
	for i in campers.size():
		var c: Dictionary = campers[i]
		var x := 36.0 + i * 80.0
		var y := 216.0 + sin(float(c["bob"])) * 3.0
		_px(x, y, 24, 32, Color(String(c["color"])))
		_px(x + 4, y - 16, 16, 16, Color("e8b88a"))
		_px(x + 4, y - 20, 16, 6, Color("333333"))  # hat
		_px(x - 4, y - 52, 32, 24, Color(0, 0, 0))  # order bubble
		_px(x - 2, y - 50, 28, 12, _mallow_color(float(Tuning.TARGETS[String(c["key"])]["c"])))
		var crave := String(c["crave"])
		if crave != "":
			_px(x + 26, y - 52, 10, 10, Color(String(Tuning.CHOCS[crave]["dot"])))
		var label: String = String(Tuning.TARGETS[String(c["key"])]["label"])[0].to_upper()
		draw_string(font, Vector2(x + 6, y - 30), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color.WHITE)
		var pw := 40.0 * float(c["patience"]) / float(c["max_patience"])
		_px(x - 8, y + 36, 40, 6, Color("440000"))
		var pc := Color("7dff8a") if float(c["patience"]) > float(c["max_patience"]) * 0.3 else Color("ff4d4d")
		_px(x - 8, y + 36, pw, 6, pc)


func _draw_plate() -> void:
	var plate_x := 392.0
	var plate_y := 300.0
	_px(plate_x - 48, plate_y, 104, 8, Color("9a9a9a"))
	_px(plate_x - 40, plate_y + 8, 88, 6, Color("777777"))
	var ly := plate_y
	var choc: String = String(state.tour["choc"])
	for l in state.layers:
		var lk := String(l)
		if lk == "graham":
			ly -= 10
			_px(plate_x - 36, ly, 80, 10, Color("d9a45b"))
		elif lk == "chocolate":
			ly -= 8
			_px(plate_x - 32, ly, 72, 8, Color(String(Tuning.CHOCS[choc]["plate"])))
			if choc == "reeses":
				_px(plate_x - 32, ly - 4, 72, 4, Color("8a4a10"))
				_px(plate_x - 20, ly - 6, 48, 2, Color("8a4a10"))
		elif lk == "mallow":
			ly -= 14
			_px(plate_x - 30, ly, 68, 14, _mallow_color(state.roast))
	var want := state.expected_next()
	var txt := "next: " + want if want != "" else "SERVE!"
	draw_string(ThemeDB.fallback_font, Vector2(plate_x - 48, plate_y + 32), txt,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("aaaaaa"))


func _draw_stick() -> void:
	var wob := 0.0
	if String(state.tour["zone"]) == "SCORCH":
		wob = sin(time_msec / 40.0) * 4.0
	var tip := state.tip
	draw_line(Vector2(504, 388), tip + Vector2(wob, 0), Color("7a5a30"), 6.0)
	_px(tip.x + wob - 12, tip.y - 18, 24, 28, _mallow_color(state.roast))
	_px(tip.x + wob - 12, tip.y - 18, 24, 6, Color(1, 1, 1, 0.35))
	if bool((state.tour["mods"] as Dictionary)["fork"]):
		var tip2 := tip + Vector2(24, 8)
		draw_line(Vector2(504, 388), tip2 + Vector2(wob, 0), Color("7a5a30"), 6.0)
		_px(tip2.x + wob - 12, tip2.y - 18, 24, 28, _mallow_color(state.roast_b))
		_px(tip2.x + wob - 12, tip2.y - 18, 24, 6, Color(1, 1, 1, 0.25))


func _draw_hud() -> void:
	var mods: Dictionary = state.tour["mods"]
	var font := ThemeDB.fallback_font
	var gw: float = 0.17 * (1.0 + float(mods["win"]))
	var gc := 0.52
	_px(16, 16, 200, 20, Color("222222"))
	_px(16 + 200 * (gc - gw), 16, 200 * gw * 2, 20, Color(1, 0.843, 0.314, 0.5))
	_px(16, 16, 200 * state.roast, 20, _mallow_color(state.roast))
	draw_rect(Rect2(16, 16, 200, 20), Color.WHITE, false, 2.0)
	draw_string(font, Vector2(16, 52), "ROAST", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
	var zone := String(state.tour["zone"])
	if zone != "":
		var zc := Color("ff4d4d") if zone == "SCORCH" else (Color("7dff8a") if zone == "SWEET" else Color("9ad1ff"))
		var zt := zone + (" x2!" if float(state.tour["flare"]) > 0.0 else "")
		draw_string(font, Vector2(92, 52), zt, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, zc)
	draw_string(font, Vector2(240, 30), "NIGHT %d/%d" % [int(state.tour["night"]), Tuning.NIGHTS],
		HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
	draw_string(font, Vector2(240, 52), "TIME %d" % int(ceil(float(state.tour["time_left"]))),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
	draw_string(font, Vector2(400, 30), "$" + str(state.tour["coins"]),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("ffd700"))
	if bool(mods["streak"]) and int(state.tour["streak"]) > 1:
		draw_string(font, Vector2(400, 52), "STREAK x" + str(state.tour["streak"]),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("ff9d2e"))
	for i in range(5):
		var hc := Color("ff4d5e") if i < int(state.tour["hearts"]) else Color("331116")
		_px(400 + i * 20, 40, 16, 14, hc)
		_px(404 + i * 20, 36, 8, 6, hc)
	var mark := ""
	if bool(state.tour["critic"]) or bool(state.tour["ev_rain"]) or float(state.tour["ev_spawn"]) != 1.0:
		mark = " *"
	draw_string(font, Vector2(16, 380),
		String(Tuning.PARKS[String(state.tour["park"])]["name"]).to_upper() + mark,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("aaaaaa"))
	var tr: String = String(state.tour["trending"])
	draw_string(font, Vector2(260, 380), "TREND: " + String(Tuning.CHOCS[tr]["name"]).to_upper(),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(String(Tuning.CHOCS[tr]["dot"])))
	if bool(mods["fork"]):
		_px(16, 60, 200, 10, Color("222222"))
		_px(16, 60, 200 * state.roast_b, 10, _mallow_color(state.roast_b))
		draw_string(font, Vector2(224, 70), "PRONG 2", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("aaaaaa"))
