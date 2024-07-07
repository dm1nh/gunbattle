extends Control

func _on_forest_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/forest.tscn")

func _on_factory_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/factory.tscn")

func _on_mosque_button_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/mosque.tscn")

