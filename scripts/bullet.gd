extends Area2D
class_name Bullet

@export var speed := 500
var direction := Vector2.RIGHT:
	set(value): direction = value.normalized()

func _process(delta):
	self.position += direction * speed * delta
	
