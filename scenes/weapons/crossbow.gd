extends Weapon

func _ready():
	firerate = 60
	damage_per_bullet = 50
	capacity = 1
	available_bullets = 10
	reload_time = 1
	projecttile = Type.Projecttile.Arrow
