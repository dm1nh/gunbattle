extends RigidBody2D
class_name RigidProjecttile

@export var speed: int = 240
var direction: Vector2 = Vector2.RIGHT
var damage: int

func _ready():
	linear_velocity = direction * speed

func _on_disappear_cooldown_timer_timeout():
	queue_free()
