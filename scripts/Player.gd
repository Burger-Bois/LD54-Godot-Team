extends CharacterBody2D
class_name Player


const MAX_MOVE_SPEED = 300.0
const MAX_HEALTH = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed = 0
var move_speed_modifier = 1.0
var health = MAX_HEALTH


func _physics_process(delta):
	
	var direction := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games.
		# That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = direction.normalized() * move_speed
	var motion = velocity * delta
	move_and_collide(motion) 
	
	#move_and_slide()
	
func _process(delta):
	set_move_speed_based_on_health()

func set_move_speed_based_on_health():
	move_speed_modifier = health / MAX_HEALTH
	
	if(move_speed_modifier < 0.5):
		move_speed_modifier = 0.5
		
	move_speed = MAX_MOVE_SPEED * move_speed_modifier

#OLD
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta
	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_maxis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	
