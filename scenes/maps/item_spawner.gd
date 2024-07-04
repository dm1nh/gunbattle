extends Node2D

var should_spawn: bool = false
var claimed_markers: Array[Marker2D] = []

var abstract_item_scene: PackedScene = preload("res://scenes/boxes/abstract_item.tscn")

func _process(_delta):
	if should_spawn:
		var selected_marker = $SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count())
		var is_duplicate = false
		for item_box in get_tree().get_nodes_in_group("item_boxes"):
			if item_box.global_position.distance_to(selected_marker.global_position) < 32:
				is_duplicate = true	

		if !is_duplicate:
			instantiate_item_scene(random_item_name_by_percentage(), selected_marker.global_position)
			should_spawn = false

func _on_spawn_cooldown_timer_timeout():
	should_spawn = true

func random_item_name_by_percentage() -> String:
	var rand = randi_range(1, 100)
	if rand > 0 and rand <= 60:
		return "health" 
	return "grenade"

func instantiate_item_scene(item_name: String, pos: Vector2) -> void:
	var node = abstract_item_scene.instantiate()
	node.item_name = item_name
	node.global_position = pos
	$Boxes.add_child(node)
