extends Weapon

func _ready():
	firerate = 60
	damage_per_bullet = 20
	capacity = 12
	reload_time = 2
	projecttile = Type.Projecttile.Bullet
