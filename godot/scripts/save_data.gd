class_name SaveData
extends RefCounted
## Persistent meta-progression, stored in user://smore_simulator.cfg.
## Mirrors the web prototype's localStorage keys: best, wins, passport, unlocks.

const PATH := "user://smore_simulator.cfg"

var best: int = 0
var wins: int = 0
var passport: Array = []   # park keys, e.g. ["yosemite", "isle"]
var unlocks: Array = []    # e.g. ["white", "caramel"]


func load_all() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	best = int(cfg.get_value("meta", "best", 0))
	wins = int(cfg.get_value("meta", "wins", 0))
	passport = cfg.get_value("meta", "passport", [])
	unlocks = cfg.get_value("meta", "unlocks", [])


func save_all() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("meta", "best", best)
	cfg.set_value("meta", "wins", wins)
	cfg.set_value("meta", "passport", passport)
	cfg.set_value("meta", "unlocks", unlocks)
	cfg.save(PATH)


func stamp_park(key: String) -> void:
	if not passport.has(key):
		passport.append(key)
		save_all()


func unlock(key: String) -> bool:
	"""Adds an unlock. Returns true if it was newly unlocked."""
	if unlocks.has(key):
		return false
	unlocks.append(key)
	save_all()
	return true


func is_unlocked(key: String) -> bool:
	return unlocks.has(key)


func record_win(coins: int) -> void:
	wins += 1
	if coins > best:
		best = coins
	save_all()


func record_best(coins: int) -> void:
	if coins > best:
		best = coins
		save_all()
