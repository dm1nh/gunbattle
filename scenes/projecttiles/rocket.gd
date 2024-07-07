extends Projecttile

func _ready():
	speed = 200
	super._ready()
	$GPUParticles2D.process_material.gravity.x = -direction.x * 50
