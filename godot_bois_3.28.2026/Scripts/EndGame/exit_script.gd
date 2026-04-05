extends Control

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	
	# if not normal time shifted during a restart, down shift until normal
	while GameManager.CURRENT_TIME_CONTROL != GameManager.TimeControl.NORMAL:
		GameManager.time_control_slow_down.emit()
	get_tree().reload_current_scene()
