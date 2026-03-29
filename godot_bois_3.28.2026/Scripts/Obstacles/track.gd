extends Path2D

@onready var animation_player_ref: AnimationPlayer = $AnimationPlayer
@export var animation_scale: float
@export var ping_pong_delay: float = 0.0

@export var speed_map: Array[float]
var current_speed_type: GameManager.TimeControl = 0

@onready var game_manager = GameManager

var start_delay: bool = false
var current_delay_timer: float = 0.0

@onready var track_follow: PathFollow2D = $PlatformFollow
var animation_name = "moving_platform"
var is_playback_reversed: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.time_control_changed.connect(_on_time_control_changed)

	animation_player_ref.current_animation = animation_name
	return


func _physics_process(delta: float) -> void:

	if start_delay:
		if current_delay_timer >= ping_pong_delay:
			is_playback_reversed = not is_playback_reversed
			animation_scale = -1 * animation_scale
			animation_player_ref.speed_scale = animation_scale * speed_map[current_speed_type]
			animation_player_ref.play(animation_name, -1, speed_map[current_speed_type], is_playback_reversed)

			current_delay_timer = 0.0
			start_delay = false
		current_delay_timer += delta * speed_map[current_speed_type]
	else:
		animation_player_ref.speed_scale = animation_scale * speed_map[current_speed_type]

	return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		if ping_pong_delay > 0.0:
			start_delay = true
	return


func _on_time_control_changed(new_time_control: GameManager.TimeControl):
	current_speed_type = new_time_control
	animation_player_ref.speed_scale = animation_scale * speed_map[current_speed_type]
	return
