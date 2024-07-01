extends Node2D

var type: Type.WeaponType
var primary: bool = true
var projecttile: Type.ProjecttileType
var damage_per_projecttile: int
var firerate: int # projecttiles per second
var reload_time: int # in seconds
var spread: int = 1
var capacity: int
var remaining_projecttiles_in_mag: int = capacity
var extra_ammo: int
