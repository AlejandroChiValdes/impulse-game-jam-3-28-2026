extends CharacterBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var JUMP_FORCE_Y = 500.0
@export var JUMP_FORCE_Y_WALL = 500.0
@export var JUMP_FORCE_X = 500.0
@export var RUN_SPEED = 200.0
@export var DIRECTION_CHANGE_FORCE_FLOOR = 5.0
@export var DIRECTION_CHANGE_FORCE_MIDAIR = 10.0
@export var TO_STANDSTILL_FORCE = 5.0

func _physics_process(delta: float):
	#always apply gravity, unconditional of any user input or horizontal momentum.
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): #also need a check for if the player is on the floor.
			velocity.y = -1 * JUMP_FORCE_Y
		elif is_on_wall():
			velocity.x = get_collided_wall_normal().x * JUMP_FORCE_X
			velocity.y = -1 * JUMP_FORCE_Y_WALL
			debug_evaluate_collisions()
			return
			
	var target_velocity = 0.0
	var direction_change_force = 1.0
	if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		target_velocity = RUN_SPEED
		
		if Input.is_action_pressed("move_left"):
			target_velocity *= -1
		if is_on_floor():
			direction_change_force *= DIRECTION_CHANGE_FORCE_FLOOR
		elif get_slide_collision_count() == 0: # player character is midair
			direction_change_force *= DIRECTION_CHANGE_FORCE_MIDAIR
	else:
		direction_change_force *= TO_STANDSTILL_FORCE
	
	
	velocity.x = move_toward(velocity.x, target_velocity, direction_change_force)
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
