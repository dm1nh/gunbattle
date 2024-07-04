extends Node2D
class_name AbstractWeapon

@export var wp_name: String
var stats: Weapon = null:
	set(value):
		stats = value
		if value != null:
			$Sprite2D.texture = value.texture
			$ShotSound.stream = value.shot_sound_effect
			$ReloadSound.stream = value.reload_sound_effect

func _ready():
	stats = WeaponDatabase.get_weapon(wp_name)
