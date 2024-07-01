class_name WeaponBox extends Area2D

var weapon: Weapon 
var body_inside: bool = false
var body_node: Node2D
signal wait_get_weapon_box(box: Area2D, weapon: Weapon)

func _process(_delta):
	if body_inside and body_node is Player:
		wait_get_weapon_box.emit(self, weapon)

func _on_body_entered(body:Node2D):
	body_node = body 
	body_inside = true

func _on_body_exited(_body:Node2D):
	body_inside = false
