extends Node2D
class_name Level


const ENEMIES_GROUP := "enemies"

const _ENEMY_COUNT_BASE := 3
const _ENEMY_COUNT_INCREMENT := 1

@onready
var enemy_spawner := $EnemySpawner as SpawnerPath

@onready
var player := $Player as Player

@export_range(0, 0, 1, "or_greater")
var wave_delay := 5.0

var _wave := 0


func _ready():
	spawn_wave()


func enemy_killed():
	if get_tree():
		var enemies := get_tree().get_nodes_in_group(ENEMIES_GROUP) as Array[Node]
		if enemies.is_empty():
			start_wave_timer()


func start_wave_timer():
	var wave_timer := Timer.new()
	wave_timer.name = "WaveTimer"
	wave_timer.wait_time = wave_delay
	wave_timer.one_shot = true
	wave_timer.timeout.connect(func():
		spawn_wave()
		wave_timer.queue_free())
	add_child(wave_timer)
	wave_timer.start()


func spawn_wave():
	_wave += 1
	var enemy_count := _ENEMY_COUNT_BASE + _ENEMY_COUNT_INCREMENT * (_wave - 1)
	
	for i in range(enemy_count):
		var enemy = enemy_spawner.get_mob() as Enemy
		enemy.name = "Enemy" + str(i)
		enemy.add_to_group(ENEMIES_GROUP)
		enemy.tree_exited.connect(enemy_killed)
		enemy.target = player
		add_child(enemy)
