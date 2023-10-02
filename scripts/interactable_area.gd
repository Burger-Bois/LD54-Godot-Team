extends Area2D
class_name InteractableArea

var action_state = "off"

var obstacle_manager: ObstacleManager

func delete_self():
	queue_free()
	
func delete_and_replace_self():
	obstacle_manager.obliterate_tile(self)

func _on_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		if enemy.box_obliterator_mode:
			delete_and_replace_self()
	else:
		action_state = "interactable"

func _on_body_exited(body):
	action_state = "off"
