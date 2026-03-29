extends Node
class_name PressureDoor

@onready var anim_body: AnimatableBody2D = $AnimatableBody2D
@export var opened_move_distance: float
@export var move_speed: float = 20.0

var starting_move_position: float
var target_move_position: float = 0.0
var current_move_progress: float = 0.0

var applying_pressure: bool

@onready var game_manager = GameManager

@export var speed_map: Array[float]
var current_time_control: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.time_control_changed.connect(_on_time_control_changed)
	starting_move_position = anim_body.position.y
	return


func _physics_process(delta: float) -> void:
	if applying_pressure:
		target_move_position = opened_move_distance
	else:
		target_move_position = 0.0
	
	anim_body.position.y = move_toward(anim_body.position.y, target_move_position, delta * move_speed * speed_map[current_time_control] )
	return


func _on_time_control_changed(new_time_control: GameManager.TimeControl):
	current_time_control = new_time_control
	return
