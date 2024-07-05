extends CanvasLayer

func _ready():
	Globals.connect("blue_hp_change", _on_blue_hp_change)
	Globals.connect("red_hp_change", _on_red_hp_change)
	Globals.connect("blue_grenades_count_change", _on_blue_grenade_change)
	Globals.connect("red_grenades_count_change", _on_red_grenade_change)
	Globals.connect("blue_in_mag_change", _on_blue_in_mag_change)
	Globals.connect("red_in_mag_change", _on_red_in_mag_change)
	Globals.connect("blue_reserve_ammo_change", _on_blue_reserve_ammo_change)
	Globals.connect("red_reserve_ammo_change", _on_red_reserve_ammo_change)
	_on_blue_hp_change()
	_on_red_hp_change()
	_on_blue_grenade_change()
	_on_red_grenade_change()
	_on_blue_in_mag_change()
	_on_red_in_mag_change()
	_on_blue_reserve_ammo_change()
	_on_red_reserve_ammo_change()

func _on_blue_hp_change():
	$PlayerBlueHealthBar.value = Globals.blue_hp

func _on_red_hp_change():
	$PlayerRedHealthBar.value = Globals.red_hp

func _on_blue_grenade_change():
	$PlayerBlueStats/Grenade/MarginContainer/Label.text =  "0" + str(Globals.blue_grenades_count) if Globals.blue_grenades_count < 10 else str(Globals.blue_grenades_count) 

func _on_red_grenade_change():
	$PlayerRedStats/Grenade/MarginContainer/Label.text =  "0" + str(Globals.red_grenades_count) if Globals.red_grenades_count < 10 else str(Globals.red_grenades_count) 

func _on_blue_in_mag_change():
	$PlayerBlueStats/Magazine/MarginContainer/Label.text =  "0" + str(Globals.blue_in_mag) if Globals.blue_in_mag < 10 else str(Globals.blue_in_mag) 

func _on_red_in_mag_change():
	$PlayerRedStats/Magazine/MarginContainer/Label.text =  "0" + str(Globals.red_in_mag) if Globals.red_in_mag < 10 else str(Globals.red_in_mag) 

func _on_blue_reserve_ammo_change():
	$PlayerBlueStats/Ammo/MarginContainer/Label.text =  "0" + str(Globals.blue_reserve_ammo) if Globals.blue_reserve_ammo < 10 else str(Globals.blue_reserve_ammo) 

func _on_red_reserve_ammo_change():
	$PlayerRedStats/Ammo/MarginContainer/Label.text =  "0" + str(Globals.red_reserve_ammo) if Globals.red_reserve_ammo < 10 else str(Globals.red_reserve_ammo) 
