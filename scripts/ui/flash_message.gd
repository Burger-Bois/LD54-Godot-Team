extends Control
class_name FlashMessage


@onready
var _label := $Label as Label

@export
var text: String:
	set(value):
		if is_instance_valid(_label):
			_label.text = value
		text = value

var _playing := false


func play():
	if not _playing:
		_playing = true
		show()
		
		var timer := Timer.new()
		timer.wait_time = 3
		timer.one_shot = true
		timer.timeout.connect(func():
			hide()
			_playing = false
			timer.queue_free())
		add_child(timer)
		timer.start()
