extends PathFollow2D

@onready var anim_body: AnimatableBody2D = $AnimatableBody2D
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#move_path = get_parent()
	#print(get_parent())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return


func _physics_process(delta: float) -> void:
	return
