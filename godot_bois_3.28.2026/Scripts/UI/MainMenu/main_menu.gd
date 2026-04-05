extends Control

func _ready():
	get_tree().paused = false
	$Panel/VBoxContainer/Play.grab_focus()
