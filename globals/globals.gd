extends Node

signal blue_hp_change
signal red_hp_change
signal blue_grenades_count_change
signal red_grenades_count_change
signal blue_ammo_change
signal red_ammo_change
signal blue_magazine_change
signal red_magazine_change

const MAX_HP: int = 100

var blue_hp: int = MAX_HP:
	get:
		return blue_hp
	set(value):
		blue_hp = clamp(value, 0, MAX_HP)
		blue_hp_change.emit()

var red_hp: int = MAX_HP:
	get:
		return red_hp
	set(value):
		red_hp = clamp(value, 0, MAX_HP)
		red_hp_change.emit()

const MAX_GRENADES_COUNT: int = 3

var blue_grenades_count: int = MAX_GRENADES_COUNT:
	get:
		return blue_grenades_count
	set(value):
		blue_grenades_count = clamp(value, 0, MAX_GRENADES_COUNT)
		blue_grenades_count_change.emit()

var red_grenades_count: int = MAX_GRENADES_COUNT:
	get:
		return red_grenades_count
	set(value):
		red_grenades_count = clamp(value, 0, MAX_GRENADES_COUNT)
		red_grenades_count_change.emit()

var blue_magazine: int = 21:
	get:
		return blue_magazine
	set(value):
		blue_magazine = value
		blue_magazine_change.emit()

var red_magazine: int = 21:
	get:
		return red_magazine
	set(value):
		red_magazine = value
		red_magazine_change.emit()

var blue_ammo: int = 21:
	get:
		return blue_ammo
	set(value):
		blue_ammo = value
		blue_ammo_change.emit()

var red_ammo: int = 21:
	get:
		return red_ammo
	set(value):
		red_ammo = value
		red_ammo_change.emit()
