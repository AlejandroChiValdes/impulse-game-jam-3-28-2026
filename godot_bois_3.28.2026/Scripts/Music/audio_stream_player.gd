extends AudioStreamPlayer

var current_position: float
var speed: float
var previous_speed: float

const TRACK_1X = preload("res://Audio/Music/GameJamSlow.mp3")
const TRACK_2X = preload("res://Audio/Music/GameJamMusic2.mp3")
const TRACK_2_5X = preload("res://Audio/Music/GameJamMusic2_5.mp3")

const SPEED_MAP = {
	0: 1.0,  # NORMAL
	1: 2.0,  # FAST
	2: 2.5   # FASTEST
}

@onready var game_manager = GameManager

func _ready() -> void:
	speed = 1.0
	previous_speed = 1.0
	stream = TRACK_1X
	play()
	game_manager.time_control_changed.connect(_on_time_control_changed)

func _on_time_control_changed(new_time_control: int) -> void:
	previous_speed = speed
	speed = SPEED_MAP[new_time_control]
	_change_speed()

func _get_accurate_position() -> float:
	return get_playback_position() \
		+ AudioServer.get_time_since_last_mix() \
		- AudioServer.get_output_latency()

func _change_speed() -> void:
	var target_position: float
	current_position = _get_accurate_position()

	# 1x -> 2x
	if previous_speed == 1.0 and speed == 2.0:
		target_position = current_position * 0.5
		stream = TRACK_2X
	# 2x -> 1x
	elif previous_speed == 2.0 and speed == 1.0:
		target_position = current_position * 2.0
		stream = TRACK_1X
	# 2x -> 2.5x
	elif previous_speed == 2.0 and speed == 2.5:
		target_position = current_position * 0.8
		stream = TRACK_2_5X
	# 2.5x -> 2x
	elif previous_speed == 2.5 and speed == 2.0:
		target_position = current_position * 1.25
		stream = TRACK_2X
	else:
		target_position = current_position

	play(target_position)
