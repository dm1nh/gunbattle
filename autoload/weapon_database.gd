extends Node2D

var cache: Dictionary = {}

var weapon_dir: String = "res://resources/weapons"

func _ready():
	var dir = DirAccess.open(weapon_dir)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		cache[file_name] = load(weapon_dir + "/" + file_name)
		file_name = dir.get_next()
	
func get_weapon(id: String) -> Weapon:
	return cache[id + ".tres"]
