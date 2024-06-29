extends Area2D
class_name Projecttile

@export var speed: int = 500
var direction: Vector2 = Vector2.RIGHT
var damage: int

func _process(delta):
	position += direction * speed * delta	

func _on_body_entered(body:Node2D):
	if body.name == "TileMap":
		queue_free()

	if "hit" in body:
		body.hit(damage)
		queue_free()

func _on_area_entered(area:Area2D):
	if area is Projecttile:
		queue_free()

