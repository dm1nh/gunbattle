class_name Player extends CharacterBody2D

const SPEED: int = 150
const JUMP_VELOCITY: int = -250
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # gravity value from project settings

@onready var player_name = name.replace("Player", "").to_lower()	
enum PlayerState { Idle, Running, Jumping, Dead }
var state: PlayerState = PlayerState.Idle
var jump_count: int = 0
var direction: Vector2 = Vector2.RIGHT

var hp: int = Globals.MAX_HP:
	get:
		return _get_global_value("hp") 
	set(value):
		_set_global_value("hp", value)

var grenades_count: int = Globals.MAX_GRENADES_COUNT:
	get:
		return _get_global_value("grenades_count")
	set(value):
		_set_global_value("grenades_count", value)

var primary_weapon: Weapon 
var secondary_weapon: Weapon = Weapons.Handgun 
var is_primary: bool = false
var current_weapon: Weapon:
	get:
		return primary_weapon if is_primary else secondary_weapon

var vulnerable_by_grenade: bool = true

signal fire(pos: Vector2, dir: Vector2, weapon: Weapon)
signal throw_grenade(pos: Vector2, dir: Vector2)
signal remaining_projecttiles_in_mag_change
signal extra_ammo_change

var can_fire_next_bullet: bool = true
var can_throw_next_grenade: bool = true
var reloading: bool = false
@onready var initialGrenadeMarkerPosition: Vector2 = $GrenadeMarker2D.position

var ak_scene: PackedScene = preload("res://scenes/weapons/ak_item.tscn")
var crossbow_scene: PackedScene = preload("res://scenes/weapons/crossbow_item.tscn")
var handgun_scene: PackedScene = preload("res://scenes/weapons/handgun_item.tscn")
var rocket_launcher_scene: PackedScene = preload("res://scenes/weapons/rocket_launcher_item.tscn")
var shotgun_scene: PackedScene = preload("res://scenes/weapons/shotgun_item.tscn")

# Inputs
var left_input: StringName
var right_input: StringName
var jump_input: StringName
var get_box_input: StringName
var fire_input: StringName
var throw_grenade_input: StringName
var swap_weapon_input: StringName

func _ready():
	connect("remaining_projecttiles_in_mag_change", _on_remaining_projecttiles_in_mag_change)
	connect("extra_ammo_change", _on_extra_ammo_change)
	set_weapon()
	get_tree().get_nodes_in_group("weapon_spawner")[0].connect("spawn_weapon_box", _on_spawn_weapon_box)

func _process(delta):
	_player_move()
	_player_jump(delta)
	move_and_slide()
	_player_swap_weapon()
	_player_fire()
	_player_throw_grenade()
	_player_animate()
	_player_die()

func _player_move():
	var movement_direction: float = Input.get_axis(left_input, right_input)
	if movement_direction:
		state = PlayerState.Running
		direction = Vector2.RIGHT if movement_direction > 0 else Vector2.LEFT
		velocity.x = movement_direction * SPEED
		$Sprite2D.flip_h = movement_direction < 0
		$WeaponItem.scale.x = direction.x
		$WeaponItem.z_index = -1 if movement_direction < 0 else 1
		$GrenadeMarker2D.position = direction * initialGrenadeMarkerPosition 

		var viewport_size = get_viewport().get_visible_rect().size
		if global_position.x > viewport_size.x:
			global_position.x = global_position.x - viewport_size.x
		if global_position.x <= 1:
			global_position.x = viewport_size.x - global_position.x
	else:
		state = PlayerState.Idle if state != PlayerState.Dead else PlayerState.Dead
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
		if primary_weapon:
			is_primary = not is_primary
			set_weapon()

func _player_fire():
	var weapon_item = $WeaponItem.get_child(0) as WeaponItem

	if Input.is_action_just_pressed(fire_input) and current_weapon.remaining_projecttiles_in_mag <= 0 and current_weapon.extra_ammo > 0 and not reloading:
		reloading = true
		$ReloadingIcon.visible = true	
		weapon_item.get_node("ReloadSound").play()
		$ReloadCooldownTimer.wait_time = weapon_item.weapon.reload_time
		$ReloadCooldownTimer.start()

	if Input.is_action_just_pressed(fire_input) and can_fire_next_bullet and current_weapon.remaining_projecttiles_in_mag > 0 and not reloading:
		$BulletCooldownTimer.wait_time = 60.0 / weapon_item.weapon.firerate
		$BulletCooldownTimer.start()
		can_fire_next_bullet = false
		var pos = weapon_item.get_node("Marker2D").global_position
		weapon_item.get_node("ShotSound").play()
		fire.emit(pos, direction, current_weapon)
		current_weapon.remaining_projecttiles_in_mag -= 1
		remaining_projecttiles_in_mag_change.emit()

func _player_throw_grenade():
	if Input.is_action_just_pressed(throw_grenade_input) and can_throw_next_grenade and grenades_count > 0:
		$GrenadeCooldownTimer.start()
		can_throw_next_grenade = false
		throw_grenade.emit($GrenadeMarker2D.global_position, direction)
		grenades_count -= 1

func _player_animate():
	if state == PlayerState.Idle:
		$StateAnimationPlayer.play("idle")
	elif state == PlayerState.Running:
		$StateAnimationPlayer.play("running")
	elif state == PlayerState.Jumping:
		$StateAnimationPlayer.play("jumping")
	elif state == PlayerState.Dead:
		$StateAnimationPlayer.play("dead")

func _player_die():
	if hp == 0:
		state = PlayerState.Dead

func set_weapon():
	can_fire_next_bullet = true
	if $WeaponItem.get_child_count() > 0:
		$WeaponItem.get_child(0).queue_free()
	var wp = get_weapon_scene_by_type(current_weapon.type).instantiate() as Node2D
	$WeaponItem.add_child(wp)
	remaining_projecttiles_in_mag_change.emit()
	extra_ammo_change.emit()

func get_item(type: Type.ItemType, amount: int):
	if type == Type.ItemType.Health:
		hp += amount
	elif type == Type.ItemType.Ammo:
		print("get more ammo")

func hit(damage: int, is_grenade: bool = false):
	if is_grenade and vulnerable_by_grenade:
		$OtherAnimationPlayer.play("hit")
		hp -= damage
		vulnerable_by_grenade = false
		$VulnerableByGrenadeTimer.start()
	if not is_grenade:
		$OtherAnimationPlayer.play("hit")
		hp -= damage

func _on_spawn_weapon_box(box: Area2D):
	box.connect("wait_get_weapon_box", _on_wait_get_weapon_box)

func _on_wait_get_weapon_box(box: Area2D, weapon: Weapon):
	if Input.is_action_just_pressed(get_box_input):
		if weapon.primary:
			primary_weapon = weapon	
		else:
			secondary_weapon = weapon
		set_weapon()
		box.queue_free()

func _on_vulnerable_by_grenade_timer_timeout():
	vulnerable_by_grenade = true

func _on_bullet_cooldown_timer_timeout():
	can_fire_next_bullet = true

func _on_grenade_cooldown_timer_timeout():
	can_throw_next_grenade = true

func _on_reload_cooldown_timer_timeout():
	reloading = false
	$ReloadingIcon.visible = false
	current_weapon.remaining_projecttiles_in_mag = current_weapon.capacity
	remaining_projecttiles_in_mag_change.emit()
	current_weapon.extra_ammo -= current_weapon.capacity
	extra_ammo_change.emit()

func _on_remaining_projecttiles_in_mag_change():
	_set_global_value("remaining_projecttiles_in_mag", current_weapon.remaining_projecttiles_in_mag)

func _on_extra_ammo_change():
	_set_global_value("extra_ammo", current_weapon.extra_ammo)

# utils
func get_weapon_scene_by_type(type: Type.WeaponType) -> PackedScene:
	if type == Type.WeaponType.Ak:
		return ak_scene
	if type == Type.WeaponType.Crossbow:
		return crossbow_scene
	if type == Type.WeaponType.Handgun:
		return handgun_scene
	if type == Type.WeaponType.RocketLauncher:
		return rocket_launcher_scene
	if type == Type.WeaponType.Shotgun:
		return shotgun_scene
	return handgun_scene

func _get_global_value(n: String):
	return Globals[player_name + "_" + n]

func _set_global_value(n: String, value):
	Globals[player_name + "_" + n] = value
