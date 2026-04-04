extends Path2D

@export var debug_view: bool = false

@onready var animation_player_ref: AnimationPlayer = $AnimationPlayer
@export var animation_scale: float
@export var base_ping_pong_delay: float = 0.0
@export var START_POINT_SECONDS: float = 0.0

@export var speed_map: Array[float]
var current_speed_type: GameManager.TimeControl = 0

@onready var game_manager = GameManager

var start_delay: bool = false
var base_delay_timer: float = 0.0

@onready var track_follow: PathFollow2D = $PlatformFollow
var animation_name = "moving_platform"
var is_playback_reversed: bool = false

var animation_playback_rate: float

@onready var stop_smoke_l: AnimatedSprite2D = $PlatformFollow/AnimatableBody2D/StopSmokeL
@onready var stop_smoke_r: AnimatedSprite2D = $PlatformFollow/AnimatableBody2D/StopSmokeR


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.time_control_changed.connect(_on_time_control_changed)

	animation_player_ref.current_animation = animation_name
	animation_player_ref.seek(START_POINT_SECONDS)

	animation_playback_rate = animation_scale * speed_map[current_speed_type]

	animation_player_ref.play(animation_name, -1, animation_playback_rate, false )

	if debug_view:
		var debug_root: Control = $PlatformFollow/AnimatableBody2D/DebugUI
		debug_root.visible = true
	return


func _physics_process(delta: float) -> void:
	if debug_view:
		_debug_options()
	
	if is_playback_reversed:
		animation_playback_rate = -1 * animation_scale * speed_map[current_speed_type]
	else:
		animation_playback_rate = animation_scale * speed_map[current_speed_type]

	if start_delay:
		if base_delay_timer >= base_ping_pong_delay:
			animation_player_ref.play(animation_name, -1, animation_playback_rate, is_playback_reversed)
			base_delay_timer = 0.0
			start_delay = false
		else:
			base_delay_timer += delta * speed_map[current_speed_type]
	else:
		animation_player_ref.play(animation_name, -1, animation_playback_rate, is_playback_reversed)
	
	return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		is_playback_reversed = not is_playback_reversed
		stop_smoke_l.play("default")
		stop_smoke_r.play("default")
		
		if base_ping_pong_delay > 0.0:
			start_delay = true
	return


func _on_time_control_changed(new_time_control: GameManager.TimeControl):
	current_speed_type = new_time_control
	stop_smoke_l.speed_scale = speed_map[current_speed_type]
	stop_smoke_r.speed_scale = speed_map[current_speed_type]
	return


func _debug_options():
	var debug_playback_rate_label: Label = $"PlatformFollow/AnimatableBody2D/DebugUI/Playback Rate"
	debug_playback_rate_label.text = str(animation_playback_rate)
	return
