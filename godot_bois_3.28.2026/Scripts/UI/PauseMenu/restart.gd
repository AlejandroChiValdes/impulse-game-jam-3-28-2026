extends Button

func _pressed():
	#TODO signal to game manager to reset time shift back to NORMAL
	get_tree().paused = false
	get_tree().reload_current_scene()
