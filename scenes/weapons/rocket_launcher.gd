extends Weapon

func _ready():
	firerate = 60
	damage_per_bullet = 100
	capacity = 1
	available_bullets = 5
	reload_time = 3
	projecttile = Type.Projecttile.Rocket
