extends Node2D

@onready var game_manager = GameManager

@export var connected_object: PressureDoor

@onready var pressure_overlap: Area2D = $OverlapPressure
@onready var anim_body: AnimatableBody2D = $AnimatableBody2D

@onready var pressed_smoke_fx: AnimatedSprite2D = $PressedSmokeFX

## Only used for smoke fx speed scaling
@export var speed_map: Array[float]
var current_time_control: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.time_control_changed.connect(_on_time_control_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	return


func _on_overlap_pressure_body_entered(body: Node2D) -> void:
	anim_body.position.y += 4
	connected_object.applying_pressure = true
	pressed_smoke_fx.speed_scale = speed_map[current_time_control]
	pressed_smoke_fx.play("default")
	return


func _on_overlap_pressure_body_exited(body: Node2D) -> void:
	anim_body.position.y -= 4
	connected_object.applying_pressure = false
	return

func _on_time_control_changed(new_time_control: GameManager.TimeControl):
	current_time_control = new_time_control
	pressed_smoke_fx.speed_scale = speed_map[current_time_control]
	return
