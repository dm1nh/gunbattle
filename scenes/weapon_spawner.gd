extends Node2D

var ak_box_scene: PackedScene = preload("res://scenes/boxes/weapons/ak_box.tscn")
var crossbow_box_scene: PackedScene = preload("res://scenes/boxes/weapons/crossbow_box.tscn")
var handgun_box_scene: PackedScene = preload("res://scenes/boxes/weapons/handgun_box.tscn")
var rocket_launcher_box_scene: PackedScene = preload("res://scenes/boxes/weapons/rocket_launcher_box.tscn")
var shotgun_box_scene: PackedScene = preload("res://scenes/boxes/weapons/shotgun_box.tscn")

var should_spawn: bool = false
signal spawn_weapon_box(box: Area2D)

func _process(_delta):
	if should_spawn:
		var selected_position = $SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count())
		var node = instantiate_weapon_scene(random_box(), selected_position.global_position)
		spawn_weapon_box.emit(node)
		should_spawn = false

func _on_spawn_cooldown_timer_timeout():
	should_spawn = true

func random_box() -> PackedScene:
	var rand = randi_range(1, 100)
	if rand > 32 and rand <= 55:
		return ak_box_scene
	if rand > 55 and rand <= 75:
		return shotgun_box_scene
	if rand > 75 and rand <= 90:
		return crossbow_box_scene
	if rand > 90 and rand <= 100:
		return rocket_launcher_box_scene
	return handgun_box_scene

func instantiate_weapon_scene(scene: PackedScene, pos: Vector2) -> Area2D:
	var instance = scene.instantiate()
	instance.global_position = pos
	$Boxes.add_child(instance)
	return instance
