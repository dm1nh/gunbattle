extends RigidBody2D

@export var speed: int = 300
const DAMAGE_RADIUS: int = 48
var exploded: int = false
const GRENADE_MAX_DAMAGE: int = 100
const GRENADE_MIN_DAMAGE: int = 50

func _ready():
	$Explosion.visible = false

func _process(_delta):
	if exploded:
		for player in get_tree().get_nodes_in_group("players"):
			var distance_from_grenade = player.global_position.distance_to(global_position)
			if distance_from_grenade <= DAMAGE_RADIUS and "hit" in player:
				var damage: int = floor(GRENADE_MIN_DAMAGE + (distance_from_grenade / DAMAGE_RADIUS) * (GRENADE_MAX_DAMAGE - GRENADE_MIN_DAMAGE))
				player.hit(damage, true)

func _on_explode_timer_timeout():
	$Sprite2D.queue_free()
	$Explosion.visible = true
	$ExplodeSound.play()
	$AnimationPlayer.play("explode")
	exploded = true
	await $AnimationPlayer.animation_finished
	exploded = false
	queue_free()

