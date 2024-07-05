extends Node2D

var should_spawn: bool = false
var claimed_markers: Array[Marker2D] = []

var abstract_weapon_box_scene: PackedScene = preload("res://scenes/boxes/abstract_weapon_box.tscn")

func _process(_delta):
	if should_spawn:
		var selected_marker = $SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count())
		var is_duplicate = false
		for weapon_box in get_tree().get_nodes_in_group("weapon_boxes"):
			if weapon_box.global_position.distance_to(selected_marker.global_position) < 32:
				is_duplicate = true	

		if !is_duplicate:
			instantiate_weapon_scene(random_weapon_name_by_percentage(), selected_marker.global_position)
			should_spawn = false

func _on_spawn_cooldown_timer_timeout():
	should_spawn = true

func random_weapon_name_by_percentage() -> String:
	var rand = randi_range(1, 100)
	if rand > 20 and rand <= 45:
		return "ak" 
	if rand > 45 and rand <= 70:
		return "shotgun" 
	if rand > 70 and rand <= 90:
		return "crossbow"
	if rand > 90 and rand <= 100:
		return "rocket_launcher"
	return "handgun"

func instantiate_weapon_scene(wp_name: String, pos: Vector2) -> void:
	var node = abstract_weapon_box_scene.instantiate()
	node.wp_name = wp_name
	node.global_position = pos
	$Boxes.add_child(node)
