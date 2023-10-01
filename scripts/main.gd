extends Node
class_name Main


@export
var main_menu_scene: PackedScene

@export
var credits_scene: PackedScene

@export
var level_scene: PackedScene

@export
var pause_scene: PackedScene

@export
var game_over_scene: PackedScene

@export
var ui_canvas_layer: CanvasLayer

var _main_menu: MainMenu
var _credits: Credits
var _level: Level
var _pause_menu: PauseMenu
var _game_over: GameOver

var _playing := false


func _ready():
	load_main_menu()


func _process(_delta: float):
	if _playing and Input.is_action_just_pressed("pause"):
			if get_tree().paused:
				unpause()
			else:
				pause()


func load_main_menu():
	_unload_all()
	
	var main_menu := main_menu_scene.instantiate() as MainMenu
	main_menu.start_button_pressed.connect(load_level)
	main_menu.credits_button_pressed.connect(load_credits)
	
	_main_menu = main_menu
	ui_canvas_layer.add_child(_main_menu)
	
	_playing = false


func load_credits():
	_unload_all()
	
	var credits := credits_scene.instantiate() as Credits
	credits.back_button_pressed.connect(load_main_menu)
	
	_credits = credits
	ui_canvas_layer.add_child(_credits)
	
	_playing = false


func load_level():
	_unload_all()
	
	# Level
	var level := level_scene.instantiate() as Level
	level.game_over.connect(show_game_over)
	
	_level = level
	add_child(_level)
	
	# Pause Menu
	var pause_menu := pause_scene.instantiate() as PauseMenu
	pause_menu.continue_button_pressed.connect(unpause)
	pause_menu.main_menu_button_pressed.connect(load_main_menu)
	pause_menu.hide()
	
	_pause_menu = pause_menu
	ui_canvas_layer.add_child(pause_menu)
	
	# Game Over Screen
	var game_over := game_over_scene.instantiate() as GameOver
	game_over.restart_button_pressed.connect(load_level)
	game_over.main_menu_button_pressed.connect(load_main_menu)
	game_over.hide()
	
	_game_over = game_over
	ui_canvas_layer.add_child(game_over)
	
	_playing = true


func pause():
	get_tree().paused = true
	if _playing:
		get_tree().paused = true
		if is_instance_valid(_pause_menu):
			_pause_menu.show()


func unpause():
	if _playing:
		get_tree().paused = false
		if is_instance_valid(_pause_menu):
			_pause_menu.hide()


func show_game_over():
	_playing = false
	if is_instance_valid(_game_over):
		_game_over.show()


func _unload_all():
	unpause()
	
	if is_instance_valid(_main_menu):
		_main_menu.queue_free()
	if is_instance_valid(_credits):
		_credits.queue_free()
	if is_instance_valid(_level):
		_level.queue_free()
	if is_instance_valid(_pause_menu):
		_pause_menu.queue_free()
	if is_instance_valid(_game_over):
		_game_over.queue_free()
