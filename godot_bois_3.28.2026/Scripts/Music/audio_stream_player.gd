extends AudioStreamPlayer

var current_position: float
var speed: float
var previous_speed: float

func _ready() -> void:
	speed = 1.0
	previous_speed = 1.0

func _process(delta: float) -> void:
	if speed != previous_speed:
		_change_speed()
		previous_speed = speed

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
	# 2x -> 1x
	elif previous_speed == 2.0 and speed == 1.0:
		target_position = current_position * 2.0
	# 2x -> 2.5x
	elif previous_speed == 2.0 and speed == 2.5:
		target_position = current_position * 0.8
	# 2.5x -> 2x
	elif previous_speed == 2.5 and speed == 2.0:
		target_position = current_position * 1.25
	else:
		target_position = current_position

	play(target_position)
