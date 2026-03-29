extends Node2D

@export var connected_object: PressureDoor

@onready var pressure_overlap: Area2D = $OverlapPressure
@onready var anim_body: AnimatableBody2D = $AnimatableBody2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	return


func _on_overlap_pressure_body_entered(body: Node2D) -> void:
	print(body)
	anim_body.position.y += 4
	connected_object.applying_pressure = true
	return


func _on_overlap_pressure_body_exited(body: Node2D) -> void:
	print("LEAVING")
	anim_body.position.y -= 4
	connected_object.applying_pressure = false
	return
