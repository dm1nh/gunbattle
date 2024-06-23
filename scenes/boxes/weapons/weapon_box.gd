extends Area2D
class_name WeaponBox

var weapon: Type.Weapon
var primary: bool = true
var body_inside: bool = false
signal wait_get_box(box: Area2D, weapon: Type.Weapon, primary: bool)

func _process(_delta):
	if body_inside:
		wait_get_box.emit(self, weapon, primary)

func _on_body_entered(_body:Node2D):
	body_inside = true

func _on_body_exited(_body:Node2D):
	body_inside = false

