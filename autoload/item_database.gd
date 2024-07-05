extends Node2D

var cache: Dictionary = {}

var item_dir: String = "res://resources/items"

func _ready():
	var dir = DirAccess.open(item_dir)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		cache[file_name] = load(item_dir + "/" + file_name)
		file_name = dir.get_next()

func get_item(id: String) -> Item:
	return cache[id + ".tres"].duplicate()
