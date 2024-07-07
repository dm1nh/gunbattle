extends Player

func _ready():
	player_name = "red"

	left_input = "r_left"
	right_input = "r_right"
	jump_input = "r_jump"
	get_box_input = "r_get_box"
	fire_input = "r_fire"
	throw_grenade_input = "r_throw_grenade"
	swap_weapon_input = "r_swap_weapon"
	reload_input = "r_reload"

	super._ready()
