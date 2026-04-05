extends Control

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent):
	if (event.is_action_pressed("pause")):
		if (visible):
			close()
		else:
			open()

func open():
	get_tree().paused = true
	show()

func close():
	get_tree().paused = false
	hide()
