extends Weapon

func _ready():
	firerate = 120
	damage_per_bullet = 20
	capacity = 5
	available_bullets = 15
	reload_time = 4
	projecttile = Type.Projecttile.Bullet
	spread = 3
