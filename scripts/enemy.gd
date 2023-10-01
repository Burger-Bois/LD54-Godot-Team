extends CharacterBody2D
class_name Enemy

signal killed

@export var knockback_speed := 200
@export var knockback_speed_dec := 0.8 # percentage velocity reduction per frame
@export var knockback_daze_duration := 0.5

@export var target: Node2D
@export var speed := 500

@export var health_max := 3
@export var health := 3

var accel = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var _daze_timer: Timer

var _alive := true
var _dazed := false

func _ready() -> void:
	nav.connect("velocity_computed", move)
	
	var daze_timer := Timer.new()
	daze_timer.name = "DazeTimer"
	daze_timer.wait_time = knockback_daze_duration
	daze_timer.one_shot = true
	daze_timer.timeout.connect(func():
		_dazed = false
		nav.avoidance_enabled = true)
	
	_daze_timer = daze_timer
	add_child(_daze_timer)
	

func _physics_process(delta):
	if _dazed:
		move(velocity * knockback_speed_dec)
	elif NavigationServer2D.map_is_active(nav.get_navigation_map()):
		var direction = Vector3()
		
		nav.target_position = target.global_position
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		
		nav.velocity = velocity.lerp(direction * speed, accel* delta)

func move(velo: Vector2) -> void:
	velocity = velo
	move_and_slide()

func hit_by(area: Area2D):
	if not _alive:
		return
	
	health += -1
	
	# Knockback and daze
	_dazed = true
	nav.avoidance_enabled = false
	_daze_timer.start()
	
	var knockback_velocity = \
		target.global_position.direction_to(global_position) * knockback_speed
	
	move(knockback_velocity)
	
	# Destroy bullet
	area.hit()
	
	# Kill
	if health <= 0:
		_alive = false
		killed.emit()
		queue_free()

func is_alive():
	return _alive
