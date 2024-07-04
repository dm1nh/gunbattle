extends Resource
class_name Item

enum ItemType { HEALTH, GRENADE }
@export var texture: Texture2D
@export var type: ItemType 
@export var amount: int
