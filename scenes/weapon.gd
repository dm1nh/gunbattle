extends Resource
class_name Weapon

enum ProjecttileType { BULLET, ARROW, ROCKET, LASER }

@export var name: String
@export var texture: Texture2D
@export var is_primary: bool = true
@export var projecttile: ProjecttileType
@export var damage_per_projecttile: int
@export var firerate: int
@export var capacity: int
@export var reserve_ammo_limit: int
@export var in_mag: int
@export var reload_time: float
@export var spread: int = 1
@export var shot_sound_effect: AudioStream
@export var reload_sound_effect: AudioStream
