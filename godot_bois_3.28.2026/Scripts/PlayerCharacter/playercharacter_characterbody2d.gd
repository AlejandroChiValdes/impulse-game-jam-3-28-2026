extends CharacterBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var JUMP_FORCE = 500.0
var DIRECTION = Vector2(0,0)
var RUN_SPEED = 200

func _physics_process(delta: float):
	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("move_left"):
		DIRECTION.x = -1
	elif Input.is_action_pressed("move_right"):
		DIRECTION.x = 1
	else:
		DIRECTION.x = 0
	
	velocity.x = DIRECTION.x * RUN_SPEED
	
	if Input.is_action_just_pressed("jump"): #also need a check for if the player is on the floor.
		velocity.y = -1 * JUMP_FORCE
	
	print("velocity y: ", velocity.y)

	move_and_slide()
	
	# debug_evaluate_collisions()

func _process(delta: float):
	if Input.is_action_just_pressed("time_shift_down"):
		#signal time shift down
		return
	elif Input.is_action_just_pressed("time_shift_up"):
		#signal time shift up
		return
	return
	
func debug_evaluate_collisions():
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
