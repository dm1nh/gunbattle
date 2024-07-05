extends RigidBody2D

@export var speed: int = 300
const DAMAGE_RADIUS: int = 48
var exploded: int = false
const GRENADE_MAX_DAMAGE: int = 120
const GRENADE_MIN_DAMAGE: int = 40

func _ready():
	$Explosion.visible = false

func _process(_delta):
	if exploded:
		for player in get_tree().get_nodes_in_group("players"):
			var distance_from_grenade: float = player.global_position.distance_to(global_position)
			if distance_from_grenade <= DAMAGE_RADIUS and "hit" in player:
				print(distance_from_grenade / DAMAGE_RADIUS)
				var damage: int = floor(GRENADE_MAX_DAMAGE - (distance_from_grenade / DAMAGE_RADIUS) * (GRENADE_MIN_DAMAGE + GRENADE_MIN_DAMAGE))
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

