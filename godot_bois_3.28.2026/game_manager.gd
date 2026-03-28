extends Node
enum TimeControl {
	NORMAL = 0,
	FAST = 1,
	FASTEST = 2
}
var CURRENT_TIME_CONTROL : TimeControl = TimeControl.NORMAL

signal time_control_changed(new_time_control : TimeControl)
signal time_control_slow_down
signal time_control_speed_up

func _ready():
	time_control_slow_down.connect(_on_time_control_slow_down)
	time_control_speed_up.connect(_on_time_control_speed_up)
	
func _on_time_control_slow_down():
	if CURRENT_TIME_CONTROL == TimeControl.NORMAL:
		return
	CURRENT_TIME_CONTROL -= 1
	time_control_changed.emit(CURRENT_TIME_CONTROL)
	
func _on_time_control_speed_up():
	if CURRENT_TIME_CONTROL == TimeControl.FASTEST:
		return
	CURRENT_TIME_CONTROL += 1
	time_control_changed.emit(CURRENT_TIME_CONTROL)
	
