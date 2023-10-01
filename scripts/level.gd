extends Node2D
class_name Level


@onready
var enemy_spawner := $EnemySpawner as SpawnerPath

@onready
var player := $Player as Player


func _ready():
	for i in range(5):
		var enemy = enemy_spawner.get_mob()
		enemy.target = player
		add_child(enemy)
