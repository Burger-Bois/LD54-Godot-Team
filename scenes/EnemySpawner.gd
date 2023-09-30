extends Path2D


@export
var enemy_scene: PackedScene


func spawn_mob():
	var enemy := enemy_scene.instantiate()
