extends Area2D
class_name InteractableArea

var action_state = "off"

var obstacle_manager: ObstacleManager

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		match action_state:
			"off":
				pass
			"interactable":
				if not obstacle_manager.carrying_obstacle:
					obstacle_manager.interact_with_tile(global_position, self)

func delete_self():
	queue_free()

func _on_body_entered(body):
	action_state = "interactable"

func _on_body_exited(body):
	action_state = "off"
