extends CharacterBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var JUMP_FORCE = 100.0
var DIRECTION = Vector2(0,0)
var RUN_SPEED = 100

func _physics_process(delta: float):
	velocity.y += GRAVITY * delta

	if Input.is_action_pressed("move_left"):
		DIRECTION.x = -1
	elif Input.is_action_pressed("move_right"):
		DIRECTION.x = 1
	else:
		DIRECTION.x = 0
	
	velocity.x = DIRECTION.x * RUN_SPEED
	
	if Input.is_action_pressed("jump"): #also need a check for if the player is on the floor.
		velocity.y = -1 * JUMP_FORCE
	
	print("velocity y: ", velocity.y)

	move_and_slide()
	
	evaluate_collisions()
	
func evaluate_collisions():
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
