extends CharacterBody2D
class_name Player

const SPEED: int = 150
const JUMP_VELOCITY: int = -300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # gravity value from project settings

enum PlayerState { Idle, Running, Jumping }
var state: PlayerState = PlayerState.Idle
var jump_count: int = 0
var direction: Vector2 = Vector2.RIGHT

var primary_weapon: Type.Weapon = Type.Weapon.None
var secondary_weapon: Type.Weapon = Type.Weapon.Handgun
var current_weapon: Type.Weapon = secondary_weapon

signal fire(pos: Vector2, dir: Vector2, damage_per_bullet: int, projecttile: Type.Projecttile, spread: int)

var can_fire_next_bullet: bool = true

var ak = preload("res://scenes/weapons/ak.tscn")
var crossbow = preload("res://scenes/weapons/crossbow.tscn")
var handgun = preload("res://scenes/weapons/handgun.tscn")
var rocket_launcher = preload("res://scenes/weapons/rocket_launcher.tscn")
var shotgun = preload("res://scenes/weapons/shotgun.tscn")

# Inputs
var left_input: StringName
var right_input: StringName
var jump_input: StringName
var get_box_input: StringName
var fire_input: StringName
var throw_grenade_input: StringName
var swap_weapon_input: StringName

func _ready():
	set_weapon()
	for weapon_box in get_tree().get_nodes_in_group("weapon_boxes"):
		weapon_box.connect("wait_get_box", _on_wait_get_weapon_box)

func _process(delta):
	_player_move()
	_player_jump(delta)
	move_and_slide()
	_player_swap_weapon()
	_player_fire()
	_player_throw_grenade()
	_player_animate()

func _player_move():
	var movement_direction: float = Input.get_axis(left_input, right_input)
	if movement_direction:
		state = PlayerState.Running
		direction = Vector2.RIGHT if movement_direction > 0 else Vector2.LEFT
		velocity.x = movement_direction * SPEED
		$Sprite2D.flip_h = movement_direction < 0
		$Weapon.scale.x = direction.x
	else:
		state = PlayerState.Idle
		velocity.x = move_toward(velocity.x, 0, SPEED) # make the players face the current direction

func _player_jump(delta):
	# falling
	if not is_on_floor():
		state = PlayerState.Jumping
		velocity.y += gravity * delta
	else:
		jump_count = 0

	if Input.is_action_just_pressed(jump_input) and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY

func _player_swap_weapon():
	if Input.is_action_just_pressed(swap_weapon_input):
		if current_weapon == secondary_weapon:
			current_weapon = primary_weapon
		else:
			current_weapon = secondary_weapon
		set_weapon()

func _player_fire():
	if Input.is_action_just_pressed(fire_input) and can_fire_next_bullet:
		var weapon_node = $Weapon.get_child(0) as Weapon
		$BulletCooldownTimer.wait_time = 60.0 / weapon_node.firerate
		$BulletCooldownTimer.start()
		can_fire_next_bullet = false
		var pos = weapon_node.get_node("Marker2D").global_position
		fire.emit(pos, direction, weapon_node.damage_per_bullet, weapon_node.projecttile, weapon_node.spread)

func _player_throw_grenade():
	if Input.is_action_just_pressed(throw_grenade_input):
		print("Throw grenade")

func _player_animate():
	if state == PlayerState.Idle:
		$AnimationPlayer.play("idle")
	elif state == PlayerState.Running:
		$AnimationPlayer.play("running")
	elif state == PlayerState.Jumping:
		$AnimationPlayer.play("jumping")

func set_weapon():
	if $Weapon.get_child_count() > 0:
		$Weapon.get_child(0).queue_free()
	var wp = get_weapon_scene_by_type(current_weapon).instantiate()
	$Weapon.add_child(wp)

func get_item(type: Type.Item, amount: int):
	if type == Type.Item.Health:
		print("healing")
	elif type == Type.Item.Ammo:
		print("get more ammo")

func hit(damage: int):
	print("hp minus ", damage)

func _on_wait_get_weapon_box(box: Area2D, weapon: Type.Weapon, primary: bool):
	if Input.is_action_just_pressed(get_box_input):
		if primary:
			primary_weapon = weapon	
		else:
			secondary_weapon = weapon
		box.queue_free()

func _on_bullet_cooldown_timer_timeout():
	can_fire_next_bullet = true

# utils
func get_weapon_scene_by_type(weapon: Type.Weapon) -> PackedScene:
	if weapon == Type.Weapon.Ak:
		return ak
	if weapon == Type.Weapon.Crossbow:
		return crossbow
	if weapon == Type.Weapon.Handgun:
		return handgun
	if weapon == Type.Weapon.RocketLauncher:
		return rocket_launcher
	if weapon == Type.Weapon.Shotgun:
		return shotgun
	return handgun
