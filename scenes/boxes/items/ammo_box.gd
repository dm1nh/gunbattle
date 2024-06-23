extends ItemBox

var amounts = [15, 30, 60]

func _ready():
	type = Type.Item.Ammo	
	amount = amounts[randi() % amounts.size()]
