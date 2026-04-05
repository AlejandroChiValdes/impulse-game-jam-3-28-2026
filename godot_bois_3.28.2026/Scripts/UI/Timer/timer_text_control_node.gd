extends Control
#listen for current time update from parent, update label to reflect new time.
@export var GameTimer : Node2D

func _ready():
	GameTimer.game_timer_updated.connect(_on_game_timer_updated)

func _on_game_timer_updated(new_time : float):
	$MarginContainer/RichTextLabel.show_new_time(new_time)
	return
