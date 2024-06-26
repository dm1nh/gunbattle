extends RigidBody2D

@export var speed: int = 300
@export var damage_radius: int = 32
var exploded: int = false
const GRENADE_DAMAGE: int = 100

func _ready():
	$Explosion.visible = false

func _process(_delta):
	if exploded:
		for player in get_tree().get_nodes_in_group("players"):
			var in_range = player.global_position.distance_to(global_position) < damage_radius
			if in_range and "hit" in player:
				player.hit(GRENADE_DAMAGE)

func _on_explode_timer_timeout():
	$Sprite2D.queue_free()
	$Explosion.visible = true
	$AnimationPlayer.play("explode")
	exploded = true
	await $AnimationPlayer.animation_finished
	queue_free()

