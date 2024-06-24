extends Weapon

func _ready():
	firerate = 600
	damage_per_bullet = 15
	capacity = 30
	reload_time = 4
	projecttile = Type.Projecttile.Bullet
