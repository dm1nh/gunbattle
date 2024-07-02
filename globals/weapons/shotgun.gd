extends Weapon

func _init():
	type = Type.WeaponType.Shotgun
	primary = true
	projecttile = Type.ProjecttileType.Bullet
	damage_per_projecttile = 15
	firerate = 300
	reload_time = 3
	spread = 3
	capacity = 5
	remaining_projecttiles_in_mag = capacity
	extra_ammo = 10
