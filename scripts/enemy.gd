extends CharacterBody2D
class_name Enemy

signal killed

@export var target: Node2D
@export var speed := 500

var accel = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var _alive := true

func _ready() -> void:
	var callable = Callable(self, "move")
	nav.connect("velocity_computed", callable)

func _physics_process(delta):
	if NavigationServer2D.map_is_active(nav.get_navigation_map()):
		var direction = Vector3()
		
		nav.target_position = target.global_position
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		
		nav.velocity = velocity.lerp(direction * speed, accel* delta)

func move(velo: Vector2) -> void:
	velocity = velo
	move_and_slide()

func hit_by(area: Area2D):
	if _alive:
		_alive = false
		killed.emit()
		queue_free()
		
		area.hit()

func is_alive():
	return _alive
