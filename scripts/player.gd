extends CharacterBody2D
class_name Player

# consts / exposed vars
@export var _max_move_speed = 150.0
@export var _max_health = 100
@export var _max_rotation_speed = 7
@export var bullet_scene : PackedScene

@onready var muzzle := $Muzzle as Marker2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed: float = 0
var cripple_speed_modifier: float = 1
var aim_speed_modifier: float = 1
var health = _max_health
var is_aiming := false

@export var fire_cooldown := 0.5
var _fire_cooldown_timer: Timer
var _can_fire := true

var mouse_position:Vector2

func _ready():
	_fire_cooldown_timer = Timer.new()
	_fire_cooldown_timer.name = "FireCooldownTimer"
	_fire_cooldown_timer.wait_time = fire_cooldown
	_fire_cooldown_timer.one_shot = true
	_fire_cooldown_timer.timeout.connect(func(): _can_fire = true)
	add_child(_fire_cooldown_timer)

func _physics_process(_delta):
	var direction := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games. That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = direction.normalized() * move_speed
	#move_and_collide(motion)
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
	cripple_speed_modifier = float(health) / _max_health
	
	if cripple_speed_modifier < 0.5 :
		cripple_speed_modifier = 0.5
	cripple_speed_modifier = clamp(cripple_speed_modifier, 0.5, 1)
	
	move_speed = _max_move_speed * cripple_speed_modifier * aim_speed_modifier
	
func try_fire():	
	if Input.is_action_pressed("fire"):
		if is_aiming and _can_fire:
			var b := bullet_scene.instantiate() as Bullet
			b.direction = Vector2.RIGHT.rotated(rotation)
			b.global_position = muzzle.global_position
			add_sibling(b)
			
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
	
#func push():
	# push enemies back, 
	# if you push too much, get tired for a few seconds
	
#func grab(pass object):
	# grab
