extends CharacterBody2D
class_name Enemy

signal killed

@export var target: Node2D
@export var speed := 500

var accel = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D

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

func kill():
	killed.emit()
	queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		kill()
