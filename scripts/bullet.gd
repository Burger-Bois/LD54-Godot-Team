extends Area2D
class_name Bullet

@export var speed := 500
var direction := Vector2.RIGHT:
	set(value): direction = value.normalized()

@export var lifetime_duration := 10.0

func _ready():
	var lifetime_timer := Timer.new()
	lifetime_timer.wait_time = lifetime_duration
	lifetime_timer.timeout.connect(queue_free)
	add_child(lifetime_timer)
	lifetime_timer.start()

func _process(delta):
	self.position += direction * speed * delta

func hit():
	queue_free()
