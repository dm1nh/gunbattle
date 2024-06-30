extends CanvasLayer

func _ready():
	Globals.connect("blue_hp_change", _on_blue_hp_change)
	Globals.connect("red_hp_change", _on_red_hp_change)
	Globals.connect("blue_grenades_count_change", _on_blue_grenade_change)
	Globals.connect("red_grenades_count_change", _on_red_grenade_change)
	Globals.connect("blue_magazine_change", _on_blue_magazine_change)
	Globals.connect("red_magazine_change", _on_red_magazine_change)
	Globals.connect("blue_ammo_change", _on_blue_ammo_change)
	Globals.connect("red_ammo_change", _on_red_ammo_change)
	_on_blue_hp_change()
	_on_red_hp_change()

func _on_blue_hp_change():
	$PlayerBlueHealthBar.value = Globals.blue_hp

func _on_red_hp_change():
	$PlayerRedHealthBar.value = Globals.red_hp

func _on_blue_grenade_change():
	$PlayerBlueStats/Grenade/MarginContainer/Label.text =  "0" + str(Globals.blue_grenades_count) if Globals.blue_grenades_count < 10 else str(Globals.blue_grenades_count) 

func _on_red_grenade_change():
	$PlayerRedStats/Grenade/MarginContainer/Label.text =  "0" + str(Globals.red_grenades_count) if Globals.red_grenades_count < 10 else str(Globals.red_grenades_count) 

func _on_blue_magazine_change():
	$PlayerBlueStats/Magazine/MarginContainer/Label.text =  "0" + str(Globals.blue_magazine) if Globals.blue_magazine < 10 else str(Globals.blue_magazine) 

func _on_red_magazine_change():
	$PlayerBlueStats/Magazine/MarginContainer/Label.text =  "0" + str(Globals.red_magazine) if Globals.red_magazine < 10 else str(Globals.red_magazine) 

func _on_blue_ammo_change():
	$PlayerBlueStats/Ammo/MarginContainer/Label.text =  "0" + str(Globals.blue_ammo) if Globals.blue_ammo < 10 else str(Globals.blue_ammo) 

func _on_red_ammo_change():
	$PlayerBlueStats/Ammo/MarginContainer/Label.text =  "0" + str(Globals.red_ammo) if Globals.red_ammo < 10 else str(Globals.red_ammo) 
