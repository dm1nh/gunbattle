extends Weapon

func _ready():
	firerate = 30
	damage_per_bullet = 100
	capacity = 2
	reload_time = 5
	projecttile = Type.Projecttile.Rocket
