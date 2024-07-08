extends CharacterBody2D
class_name Player

var viewport_size: Vector2
const SPEED: int = 150
const JUMP_VELOCITY: int = -250
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # gravity value from project settings

var abstract_weapon_scene: PackedScene = preload("res://scenes/abstract_weapon.tscn")

var player_name: String
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

@onready var primary_weapon: Weapon
@onready var secondary_weapon: Weapon = WeaponDatabase.get_weapon("handgun")
var is_primary: bool = false
@onready var current_weapon: Weapon = secondary_weapon:
	get:
		return primary_weapon if is_primary else secondary_weapon

var vulnerable_by_grenade: bool = true

signal fire(pos: Vector2, dir: Vector2, stats: Weapon)
signal throw_grenade(pos: Vector2, dir: Vector2)
signal in_mag_change()
signal reserve_ammo_change()

var can_fire_next_bullet: bool = true
var can_throw_next_grenade: bool = true
var reloading: bool = false
@onready var initialGrenadeMarkerPosition: Vector2 = $GrenadeMarker2D.position

# Inputs
var left_input: StringName
var right_input: StringName
var jump_input: StringName
var get_box_input: StringName
var fire_input: StringName
var throw_grenade_input: StringName
var swap_weapon_input: StringName
var reload_input: StringName

func _ready():
	viewport_size = get_viewport().get_visible_rect().size
	_on_in_mag_change()
	_on_reserve_ammo_change()
	connect("in_mag_change", _on_in_mag_change)
	connect("reserve_ammo_change", _on_reserve_ammo_change)
	set_weapon()

func _process(delta):
	if not state == PlayerState.Dead:
		_player_move()
		_player_jump()
		_player_swap_weapon()
		_player_fire()
		_player_throw_grenade()
	_player_fall(delta)
	_player_animate()
	_player_die()
	move_and_slide()

func _player_move():
	var movement_direction: float = Input.get_axis(left_input, right_input)
	if movement_direction:
		state = PlayerState.Running
		direction = Vector2.RIGHT if movement_direction > 0 else Vector2.LEFT
		velocity.x = movement_direction * SPEED
		$Sprite2D.flip_h = movement_direction < 0
		$Weapon.scale.x = direction.x
		$Weapon.z_index = 0 if movement_direction < 0 else 1
		$GrenadeMarker2D.position = direction * initialGrenadeMarkerPosition 

		if global_position.x >= viewport_size.x:
			global_position.x = global_position.x - viewport_size.x
		if global_position.x <= 0:
			global_position.x = viewport_size.x - global_position.x
	else:
		state = PlayerState.Idle if state != PlayerState.Dead else PlayerState.Dead
		velocity.x = move_toward(velocity.x, 0, SPEED) # make the players face the current direction

func _player_fall(delta):
	if not is_on_floor():
		state = PlayerState.Jumping
		velocity.y += gravity * delta
	else:
		jump_count = 0

func _player_jump():
	if Input.is_action_just_pressed(jump_input) and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY

func _player_swap_weapon():
	if Input.is_action_just_pressed(swap_weapon_input):
		if primary_weapon:
			is_primary = not is_primary
			set_weapon()

func _player_fire():
	var weapon_item = $Weapon.get_child(0) as AbstractWeapon

	if (current_weapon.in_mag <= 0 and current_weapon.reserve_ammo_limit > 0 and not reloading) or Input.is_action_just_pressed(reload_input):
		reloading = true
		$ReloadingIcon.visible = true	
		weapon_item.get_node("ReloadSound").play()
		$ReloadCooldownTimer.wait_time = weapon_item.stats.reload_time
		$ReloadCooldownTimer.start()

	if Input.is_action_just_pressed(fire_input) and can_fire_next_bullet and current_weapon.in_mag > 0 and not reloading:
		$BulletCooldownTimer.wait_time = 60.0 / weapon_item.stats.firerate
		$BulletCooldownTimer.start()
		can_fire_next_bullet = false
		var pos = weapon_item.get_node("Marker2D").global_position
		weapon_item.get_node("ShotSound").play()
		fire.emit(pos, direction, current_weapon)
		current_weapon.in_mag -= 1
		in_mag_change.emit()

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
	if hp == 0 or global_position.y > viewport_size.y:
		state = PlayerState.Dead
		if player_name == "blue":
			Globals.winner_name = "red"
		else:
			Globals.winner_name = "blue"
		if Input.is_action_just_pressed("space"):
			get_tree().change_scene_to_file("res://scenes/map_selection.tscn")

func set_weapon():
	can_fire_next_bullet = true
	for weapon_node in $Weapon.get_children():
		weapon_node.queue_free()
	var wp = abstract_weapon_scene.instantiate() as AbstractWeapon
	wp.wp_name = current_weapon.name
	$Weapon.add_child(wp)
	in_mag_change.emit()
	reserve_ammo_change.emit()

func get_item(stats: Item):
	if stats.type == Item.ItemType.HEALTH:
		hp += stats.amount
	if stats.type == Item.ItemType.GRENADE:
		grenades_count += stats.amount

func hit(damage: int, is_grenade: bool = false):
	if is_grenade and vulnerable_by_grenade:
		$OtherAnimationPlayer.play("hit")
		hp -= damage
		vulnerable_by_grenade = false
		$VulnerableByGrenadeTimer.start()
	if not is_grenade:
		$OtherAnimationPlayer.play("hit")
		hp -= damage

func get_weapon(box: Area2D, stats: Weapon):
	if Input.is_action_just_pressed(get_box_input):
		if stats.is_primary:
			primary_weapon = stats	
		else:
			secondary_weapon = stats
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
	var to_add_in_mag = current_weapon.capacity - current_weapon.in_mag
	current_weapon.in_mag = current_weapon.in_mag + to_add_in_mag 
	current_weapon.reserve_ammo_limit -= to_add_in_mag
	in_mag_change.emit()
	reserve_ammo_change.emit()

func _on_in_mag_change():
	_set_global_value("in_mag", current_weapon.in_mag)

func _on_reserve_ammo_change():
	_set_global_value("reserve_ammo", current_weapon.reserve_ammo_limit)

# utils
func _get_global_value(n: String):
	return Globals[player_name + "_" + n]

func _set_global_value(n: String, value):
	Globals[player_name + "_" + n] = value
