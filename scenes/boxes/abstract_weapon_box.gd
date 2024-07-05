extends Area2D
class_name AbstractWeaponBox

@export var wp_name: String
var stats: Weapon = null:
	set(value):
		stats = value
		if value != null:
			$Sprite2D.texture = value.texture

var body_inside: bool = false
var body_node: Node2D

func _ready():
	stats = WeaponDatabase.get_weapon(wp_name)

func _process(_delta):
	if body_inside and body_node is Player and "get_weapon" in body_node:
		body_node.get_weapon(self, stats)

func _on_body_entered(body:Node2D):
	body_node = body 
	body_inside = true

func _on_body_exited(_body:Node2D):
	body_inside = false

func _on_disappear_cooldown_timer_timeout():
	queue_free()
