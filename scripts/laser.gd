extends RayCast2D
class_name Laser


func _process(_delta):
	queue_redraw()


func _draw():
	if is_colliding():
		draw_line(position, to_local(get_collision_point()), Color.RED)
	else:
		draw_line(position, target_position, Color.RED)
