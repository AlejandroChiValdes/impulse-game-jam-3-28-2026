extends CharacterBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var JUMP_FORCE_Y = 500.0
@export var JUMP_FORCE_X = 1000.0
@export var RUN_SPEED = 200
@export var DIRECTION_CHANGE_FORCE_FLOOR = 20
@export var DIRECTION_CHANGE_FORCE_MIDAIR = 20
var DIRECTION = Vector2(0,0)

func _physics_process(delta: float):
	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("move_left"):
		DIRECTION.x = -1
		velocity.x = DIRECTION.x * RUN_SPEED
	elif Input.is_action_pressed("move_right"):
		DIRECTION.x = 1
		velocity.x = DIRECTION.x * RUN_SPEED
	else:
		if is_on_floor(): #also need a check for if the player is on the floor.
			velocity.x = move_toward(velocity.x, 0, DIRECTION_CHANGE_FORCE_FLOOR)
		elif get_slide_collision_count() == 0:
			velocity.x = move_toward(velocity.x, 0, DIRECTION_CHANGE_FORCE_MIDAIR)
	
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): #also need a check for if the player is on the floor.
			velocity.y = -1 * JUMP_FORCE_Y
		elif is_on_wall():
			DIRECTION.x = get_collided_wall_normal().x
			velocity.x = DIRECTION.x * JUMP_FORCE_X
			velocity.y = -1 * JUMP_FORCE_Y
			debug_evaluate_collisions()
	
	

	move_and_slide()

func get_collided_wall_normal():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		return collision.get_normal()

func _process(delta: float):
	if Input.is_action_just_pressed("time_shift_down"):
		GameManager.time_control_slow_down.emit()
	elif Input.is_action_just_pressed("time_shift_up"):
		GameManager.time_control_speed_up.emit()
		return
	
func debug_evaluate_collisions():
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		continue
