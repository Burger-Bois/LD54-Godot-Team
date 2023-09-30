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
var move_speed_modifier: float = 1
var health = _max_health
var is_aiming := false

var mouse_position:Vector2

func _physics_process(delta):
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
	set_move_speed_based_on_health()
	try_fire()
	handle_player_rotation(delta)
	
func handle_player_rotation(delta):
	##self.look_at(mouse_position) # bad, non-phsysics based rotation
	mouse_position = self.get_global_mouse_position()
	var rotation_direction := get_angle_to(mouse_position)
	# var rotation_speed = length of tangent of player's aim vector to the mouse % 
	rotation += rotation_direction * _max_rotation_speed * delta
	
func set_move_speed_based_on_health():
	move_speed_modifier = health / _max_health
	
	if move_speed_modifier < 0.5 :
		move_speed_modifier = 0.5
	move_speed_modifier = clamp(move_speed_modifier, 0.5, 1)
	move_speed = _max_move_speed * move_speed_modifier
	
func toggle_aim():
	# unholtser gun + aim in one action
	if is_aiming :
		is_aiming= false
	is_aiming = true
	
func try_fire():	
	if Input.is_action_just_pressed("fire"):
		var b := bullet_scene.instantiate() as Bullet
		b.direction = Vector2.RIGHT.rotated(rotation)
		b.global_position = muzzle.global_position
		add_sibling(b)

	# if aiming
		# fire gun
	# else
		# push action
		# grab
		
#func push():
	# push enemies back, 
	# if you push too much, get tired for a few seconds
	
#func grab(pass object):
	# grab
