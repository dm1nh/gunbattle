extends Area2D
class_name AbstractItem

@export var item_name: String
var stats: Item = null:
	set(value):
		stats = value
		if value != null:
			$Sprite2D.texture = value.texture


func _ready():
	stats = ItemDatabase.get_item(item_name)	

func _on_body_entered(body: Node2D):
	if "get_item" in body:
		body.get_item(stats)
		queue_free()
