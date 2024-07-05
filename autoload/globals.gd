extends Node

signal blue_hp_change
signal red_hp_change
signal blue_grenades_count_change
signal red_grenades_count_change
signal blue_reserve_ammo_change
signal red_reserve_ammo_change
signal blue_in_mag_change
signal red_in_mag_change

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

var blue_in_mag: int:
	get:
		return blue_in_mag
	set(value):
		blue_in_mag = value
		blue_in_mag_change.emit()

var red_in_mag: int:
	get:
		return red_in_mag
	set(value):
		red_in_mag = value
		red_in_mag_change.emit()

var blue_reserve_ammo: int:
	get:
		return blue_reserve_ammo
	set(value):
		blue_reserve_ammo = value
		blue_reserve_ammo_change.emit()

var red_reserve_ammo: int:
	get:
		return red_reserve_ammo
	set(value):
		red_reserve_ammo = value
		red_reserve_ammo_change.emit()
