extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/projecttiles/bullet.tscn")
var arrow_scene: PackedScene = preload("res://scenes/projecttiles/arrow.tscn")
var rocket_scene: PackedScene = preload("res://scenes/projecttiles/rocket.tscn")
var laser_scene: PackedScene = preload("res://scenes/projecttiles/laser.tscn")
var thorn_scene: PackedScene = preload("res://scenes/projecttiles/thorn.tscn")

var grenade_scene: PackedScene = preload("res://scenes/projecttiles/grenade.tscn")

func _ready():
	for player in get_tree().get_nodes_in_group("players"):
		player.connect("fire", _on_player_fire)
		player.connect("throw_grenade", _on_player_throw_grenade)

func _on_player_fire(pos: Vector2, dir: Vector2, stats: Weapon):
	if stats.spread == 3:
		_create_projecttile_scene(pos, dir.rotated(PI/24), stats.damage_per_projecttile, stats.projecttile)
		_create_projecttile_scene(pos, dir.rotated(-PI/24), stats.damage_per_projecttile, stats.projecttile)
	_create_projecttile_scene(pos, dir, stats.damage_per_projecttile, stats.projecttile)

func _on_player_throw_grenade(pos: Vector2, dir: Vector2):
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	if dir.x > 0:
		grenade.linear_velocity = dir.rotated(-PI/4) * grenade.speed
	else:
		grenade.linear_velocity = dir.rotated(PI/4) * grenade.speed
	$Projecttiles.add_child(grenade)
	grenade.get_node("ThrowGrenadeSound").play()
	
func _create_projecttile_scene(pos: Vector2, dir: Vector2, damage_per_projecttile: int, projecttile: Weapon.ProjecttileType):
	var scene: PackedScene
	if projecttile == Weapon.ProjecttileType.BULLET:
		scene = bullet_scene
	elif projecttile == Weapon.ProjecttileType.ARROW:
		scene = arrow_scene
	elif projecttile == Weapon.ProjecttileType.ROCKET:
		scene = rocket_scene
	elif projecttile == Weapon.ProjecttileType.LASER:
		scene = laser_scene
	elif projecttile == Weapon.ProjecttileType.THORN:
		scene = thorn_scene

	var instance = scene.instantiate()
	instance.position = pos
	instance.direction = dir
	instance.damage = damage_per_projecttile
	$Projecttiles.add_child(instance)
