extends Node2D


@onready
var enemy_spawner := $EnemySpawner as EnemySpawner

@onready
var player := $Player as Player


func _ready():
	for i in range(5):
		var enemy = enemy_spawner.get_mob()
		enemy.target = player
		add_child(enemy)
