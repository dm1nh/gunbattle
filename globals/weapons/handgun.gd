extends Weapon

func _init():
	type = Type.WeaponType.Handgun
	primary = false
	projecttile = Type.ProjecttileType.Bullet
	damage_per_projecttile = 20
	firerate = 60
	reload_time = 2
	spread = 1
	capacity = 7
	extra_ammo = 14
