extends Node2D
class_name Level


signal game_over
signal wave_spawning

const ENEMIES_GROUP := "enemies"

const _ENEMY_COUNT_BASE := 2
var _ENEMY_COUNT_INCREMENT := 0

@onready
var enemy_spawner := $EnemySpawner as SpawnerPath

@onready
var player := $Player as Player

@export_range(0, 0, 1, "or_greater")
var wave_delay := 5.0

var wave := 0

var _playing := false


func _ready():
	spawn_wave()
	_playing = true


func enemy_killed():
	var enemies := get_tree().get_nodes_in_group(ENEMIES_GROUP) as Array[Node]
	if enemies.all(func(enemy): return not enemy.is_alive()):
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
	wave += 1
	_ENEMY_COUNT_INCREMENT += wave % 2
	var enemy_count := _ENEMY_COUNT_BASE + _ENEMY_COUNT_INCREMENT
	
	for i in range(enemy_count):
		var enemy = enemy_spawner.get_mob() as Enemy
		enemy.name = "Enemy" + str(i)
		enemy.add_to_group(ENEMIES_GROUP)
		enemy.killed.connect(enemy_killed)
		enemy.target = player
		enemy.speed += (wave * 3)
		enemy.health = randi_range(1, (wave / 3))
		add_child(enemy)
	
	wave_spawning.emit()


func finish_game():
	if _playing:
		_playing = false
		call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
		game_over.emit()
