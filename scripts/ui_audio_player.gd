extends Node


@onready
var button_hover_audio := $ButtonHoverAudio

@onready
var button_select_audio := $ButtonSelectAudio


func _ready():
	connect_nodes(get_tree().root)
	get_tree().node_added.connect(connect_node)


func connect_nodes(parent: Node):
	for node in parent.get_children():
		connect_node(node)
		connect_nodes(node)


func connect_node(node: Node):
	if node is Button:
		connect_button(node as Button)


func connect_button(button: Button):
	button.mouse_entered.connect(button_hover_audio.play)
	button.pressed.connect(button_select_audio.play)
