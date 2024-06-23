extends CanvasLayer

func _ready():
	Globals.connect("blue_health_change", _on_blue_health_change)
	Globals.connect("red_health_change", _on_red_health_change)
	_on_blue_health_change()
	_on_red_health_change()

func _on_blue_health_change():
	$PlayerBlueHealthBar.value = Globals.blue_health

func _on_red_health_change():
	$PlayerRedHealthBar.value = Globals.red_health
