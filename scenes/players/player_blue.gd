extends Player

func _ready():
	player_name = "blue"

	left_input = "b_left"
	right_input = "b_right"
	jump_input = "b_jump"
	get_box_input = "b_get_box"
	fire_input = "b_fire"
	throw_grenade_input = "b_throw_grenade"
	swap_weapon_input = "b_swap_weapon"
	reload_input = "b_reload"

	super._ready()
