extends Area2D
class_name ItemBox

var type: Type.Item
var amount: int


func _on_body_entered(body:Node2D):
	if "get_item" in body:
		body.get_item(type, amount)
		queue_free()
