extends Weapon

func _init():
	type = Type.WeaponType.Ak	
	primary = true
	projecttile = Type.ProjecttileType.Bullet
	damage_per_projecttile = 15
	firerate = 600
	reload_time = 3
	spread = 1
	capacity = 30
	remaining_projecttiles_in_mag = capacity
	extra_ammo = 30
