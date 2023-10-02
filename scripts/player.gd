extends CharacterBody2D
class_name Player

signal killed

# consts / exposed vars
@export var _max_move_speed = 150.0
@export var _max_health = 3
@export var _max_rotation_speed = 7
@export var bullet_scene : PackedScene
@export var fire_cooldown := 0.5

@export_subgroup("hit")
@export var knockback_duration := 0.1
@export var knockback_speed := 400.0
@export var invincibility_duration := 1.0

@onready var muzzle := $Muzzle as Marker2D
@onready var fire_sound := $FireSound as AudioStreamPlayer
@onready var death_sound := $DeathSound as AudioStreamPlayer
@onready var hitbox := $Hitbox as Area2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed: float = 0
var cripple_speed_modifier: float = 1
var aim_speed_modifier: float = 1
var health = _max_health
var is_aiming := false

var _fire_cooldown_timer: Timer
var _can_fire := true

var _daze_timer: Timer
var _dazed := false

var _knockback_direction: Vector2

var _invincible_timer: Timer
var _invincible := false

var _carrying := false

var mouse_position:Vector2

func _ready():
	_fire_cooldown_timer = Timer.new()
	_fire_cooldown_timer.name = "FireCooldownTimer"
	_fire_cooldown_timer.wait_time = fire_cooldown
	_fire_cooldown_timer.one_shot = true
	_fire_cooldown_timer.timeout.connect(func(): _can_fire = true)
	add_child(_fire_cooldown_timer)
	
	_daze_timer = Timer.new()
	_daze_timer.name = "DazeTimer"
	_daze_timer.wait_time = knockback_duration
	_daze_timer.one_shot = true
	_daze_timer.timeout.connect(func(): _dazed = false)
	add_child(_daze_timer)
	
	_invincible_timer = Timer.new()
	_invincible_timer.name = "InvincibilityTimer"
	_invincible_timer.wait_time = invincibility_duration
	_invincible_timer.one_shot = true
	_invincible_timer.timeout.connect(end_invincibility)
	add_child(_invincible_timer)

func _physics_process(_delta):
	if _dazed:
		velocity = _knockback_direction * knockback_speed
	else:
		var direction := Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		velocity = direction.normalized() * move_speed
	
	move_and_slide()

func _process(delta):
	handle_player_rotation(delta)
	try_aim()
	try_fire()
	modify_move_speed()

func handle_player_rotation(delta):
	##self.look_at(mouse_position) # bad, non-phsysics based rotation
	mouse_position = self.get_global_mouse_position()
	var rotation_direction := get_angle_to(mouse_position)
	# var rotation_speed = length of tangent of player's aim vector to the mouse % 
	rotation += rotation_direction * _max_rotation_speed * delta

func modify_move_speed():
	# We can add this back later
#	cripple_speed_modifier = float(health) / _max_health
#
#	if cripple_speed_modifier < 0.5 :
#		cripple_speed_modifier = 0.5
#	cripple_speed_modifier = clamp(cripple_speed_modifier, 0.5, 1)
#
#	move_speed = _max_move_speed * cripple_speed_modifier * aim_speed_modifier
	
	move_speed = _max_move_speed * aim_speed_modifier

func try_fire():	
	if Input.is_action_pressed("fire"):
		if is_aiming and _can_fire and not _carrying:
			var b := bullet_scene.instantiate() as Bullet
			b.direction = Vector2.RIGHT.rotated(rotation)
			b.global_position = muzzle.global_position
			add_sibling(b)
			
			fire_sound.play()
			
			_can_fire = false
			_fire_cooldown_timer.start()
		else :
			pass # TODO implement pushing, picking up?

func try_aim():
	# unholtser gun + aim in one action
	if Input.is_action_pressed("aim"):
		is_aiming = true
		aim_speed_modifier = 0.5
	else :
		is_aiming = false
		aim_speed_modifier = 1

func hit(node_hit_by: Node2D):
	if _invincible or health <= 0:
		return
	
	health += -1
	
	_dazed = true
	_daze_timer.start()
	
	_knockback_direction = node_hit_by.global_position.direction_to(global_position)
	
	_invincible = true
	_invincible_timer.start()
	
	if health <= 0:
		die()

func die():
	killed.emit()
	death_sound.play()
	call_deferred("set_process_mode", PROCESS_MODE_DISABLED)

func end_invincibility():
	_invincible = false
	if hitbox.has_overlapping_bodies():
		hit(hitbox.get_overlapping_bodies()[0])

func set_carrying(value: bool):
	_carrying = value
