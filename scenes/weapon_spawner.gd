extends Node2D

var should_spawn: bool = false
var claimed_markers: Array[Marker2D] = []
signal spawn_weapon_box(box: Area2D)

var abstract_weapon_box_scene: PackedScene = preload("res://scenes/boxes/abstract_weapon_box.tscn")

func _process(_delta):
	if should_spawn:
		var selected_marker = $SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count())
		var is_duplicate = false
		for weapon_box in get_tree().get_nodes_in_group("weapon_boxes"):
			if weapon_box.global_position.distance_to(selected_marker.global_position) < 32:
				is_duplicate = true	

		if !is_duplicate:
			var node = instantiate_weapon_scene(random_box(), selected_marker.global_position)
			spawn_weapon_box.emit(node)
			should_spawn = false

func _on_spawn_cooldown_timer_timeout():
	should_spawn = true

func random_box() -> String:
	var rand = randi_range(1, 100)
	if rand > 32 and rand <= 55:
		return "ak" 
	if rand > 55 and rand <= 75:
		return "shotgun" 
	if rand > 75 and rand <= 90:
		return "crossbow"
	if rand > 90 and rand <= 100:
		return "rocket_launcher"
	return "handgun"

func instantiate_weapon_scene(wp_name: String, pos: Vector2) -> Area2D:
	var node = abstract_weapon_box_scene.instantiate()
	node.wp_name = wp_name
	node.global_position = pos
	$Boxes.add_child(node)
	return node
