extends RigidProjecttile

const ROTATION_SPEED: float = 32 * 2 * PI # 32 rps

func _physics_process(delta):
	rotation += direction.x * ROTATION_SPEED * delta

func _on_area_2d_body_entered(body:Node2D):
	if "hit" in body:
		body.hit(damage)
