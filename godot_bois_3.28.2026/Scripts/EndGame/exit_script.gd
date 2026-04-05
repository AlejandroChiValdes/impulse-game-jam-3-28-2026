extends Control

@export var GameTimer : Node2D

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	show()
	$Panel/VBoxContainer/RestartButton.grab_focus()
	$Panel/VBoxContainer/ElapsedTimeLabel.update_text(GameTimer.GAME_TIME)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	
	# if not normal time shifted during a restart, down shift until normal
	GameManager.reset_level.emit()
	get_tree().reload_current_scene()
