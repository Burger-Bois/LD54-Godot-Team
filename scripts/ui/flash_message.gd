extends Control
class_name FlashMessage


const FLASH_ANIMATION := "flash"

@onready
var _label := $Label as Label

@onready
var _animation := $AnimationPlayer as AnimationPlayer

@export
var text: String:
	set(value):
		if is_instance_valid(_label):
			_label.text = value
		text = value

var _playing := false


func play():
	_animation.play(FLASH_ANIMATION)
