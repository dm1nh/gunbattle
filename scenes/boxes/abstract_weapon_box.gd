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
signal wait_get_weapon_box(box: Area2D, stats: Weapon)

func _ready():
	stats = WeaponDatabase.get_weapon(wp_name)

func _process(_delta):
	if body_inside and body_node is Player:
		wait_get_weapon_box.emit(self, stats)

func _on_body_entered(body:Node2D):
	body_node = body 
	body_inside = true

func _on_body_exited(_body:Node2D):
	body_inside = false
