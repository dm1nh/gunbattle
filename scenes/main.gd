extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/projecttiles/bullet.tscn")
var arrow_scene: PackedScene = preload("res://scenes/projecttiles/arrow.tscn")
var rocket_scene: PackedScene = preload("res://scenes/projecttiles/rocket.tscn")

var grenade_scene: PackedScene = preload("res://scenes/projecttiles/grenade.tscn")

func _ready():
	for player in get_tree().get_nodes_in_group("players"):
		player.connect("fire", _on_player_fire)
		player.connect("throw_grenade", _on_player_throw_grenade)

func _on_player_fire(pos: Vector2, dir: Vector2, damage_per_bullet: int, projecttile: Type.Projecttile, spread: int):
	if spread > 1:
		_create_projecttile_scene(pos, dir.rotated(PI/24), damage_per_bullet, projecttile)
		_create_projecttile_scene(pos, dir.rotated(-PI/24), damage_per_bullet, projecttile)
	_create_projecttile_scene(pos, dir, damage_per_bullet, projecttile)

func _on_player_throw_grenade(pos: Vector2, dir: Vector2):
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity = dir.rotated(-PI/4) * grenade.speed
	$Projecttiles.add_child(grenade)
	grenade.get_node("ThrowGrenadeSound").play()
	
func _create_projecttile_scene(pos: Vector2, dir: Vector2, damage_per_bullet: int, projecttile: Type.Projecttile):
	var scene: PackedScene
	if projecttile == Type.Projecttile.Bullet:
		scene = bullet_scene
	elif projecttile == Type.Projecttile.Arrow:
		scene = arrow_scene
	elif projecttile == Type.Projecttile.Rocket:
		scene = rocket_scene

	var instance = scene.instantiate()
	instance.position = pos
	instance.direction = dir
	instance.damage = damage_per_bullet
	$Projecttiles.add_child(instance)
