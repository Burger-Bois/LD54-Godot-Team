extends Control
class_name GameOver


signal restart_button_pressed
signal main_menu_button_pressed

@onready
var score_label := $Rows/ScoreRow/Score as Label

var score := 0:
	set(value):
		score_label.text = str(value)
		score = value
