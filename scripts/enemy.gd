extends CharacterBody2D

@export var target: Node2D
@export var speed := 500

var accel = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta):
	var direction = Vector3()
	
	nav.target_position = target.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel* delta)
	move_and_slide()
