extends Node

signal blue_health_change
signal red_health_change

const MAX_HP: int = 100

var blue_health: int = MAX_HP:
	get:
		return blue_health
	set(value):
		blue_health = clamp(value, 0, MAX_HP)
		blue_health_change.emit()

var red_health: int = MAX_HP:
	get:
		return red_health
	set(value):
		red_health = clamp(value, 0, MAX_HP)
		red_health_change.emit()

const MAX_GRENADES: int = 3

var blue_grenades: int = MAX_GRENADES:
	get:
		return blue_grenades
	set(value):
		blue_grenades = clamp(value, 0, MAX_GRENADES)

var red_grenades: int = MAX_GRENADES:
	get:
		return red_grenades
	set(value):
		red_grenades = clamp(value, 0, MAX_GRENADES)
