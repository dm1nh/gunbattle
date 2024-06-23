extends Weapon

func _ready():
	firerate = 120
	damage_per_bullet = 20
	projecttile = Type.Projecttile.Bullet
	spread = 3
