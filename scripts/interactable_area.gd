extends Area2D
class_name InteractableArea

var action_state = "off"

var obstacle_manager: ObstacleManager

func delete_self():
	queue_free()

func _on_body_entered(body):
	action_state = "interactable"

func _on_body_exited(body):
	action_state = "off"
