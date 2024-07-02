extends Weapon

func _init():
	type = Type.WeaponType.RocketLauncher
	primary = true
	projecttile = Type.ProjecttileType.Rocket
	damage_per_projecttile = 120
	firerate = 60
	reload_time = 2
	spread = 1
	capacity = 3
	remaining_projecttiles_in_mag = capacity
	extra_ammo = 6
