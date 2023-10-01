extends Path2D
class_name SpawnerPath


@export
var enemy_scene: PackedScene

@onready
var spawn_location := $SpawnLocation as PathFollow2D


func get_mob() -> CharacterBody2D:
	spawn_location.progress_ratio = randf()
	
	var enemy := enemy_scene.instantiate() as CharacterBody2D
	enemy.position = spawn_location.position
	enemy.set_collision_mask_value(4, true)
	
	return enemy
