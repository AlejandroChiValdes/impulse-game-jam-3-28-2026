extends Button

func _pressed():
	#TODO signal to game manager to reset time shift back to NORMAL
	GameManager.reset_level.emit()
	get_tree().paused = false
	get_tree().reload_current_scene()
