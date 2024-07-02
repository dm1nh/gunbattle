extends Weapon

func _init():
	type = Type.WeaponType.Crossbow	
	primary = true
	projecttile = Type.ProjecttileType.Arrow
	damage_per_projecttile = 50
	firerate = 60
	reload_time = 1
	spread = 1
	capacity = 1
	remaining_projecttiles_in_mag = capacity
	extra_ammo = 10
