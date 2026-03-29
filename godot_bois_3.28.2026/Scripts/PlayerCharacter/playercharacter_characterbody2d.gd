extends CharacterBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var JUMP_FORCE_Y = 50.0
@export var JUMP_FORCE_Y_WALL = 50.0
@export var JUMP_FORCE_X = 500.0
@export var RUN_SPEED = 200.0
@export var DIRECTION_CHANGE_FORCE_FLOOR = 5.0
@export var DIRECTION_CHANGE_FORCE_MIDAIR = 10.0
@export var TO_STANDSTILL_FORCE_FLOOR = 10.0
@export var TO_STANDSTILL_FORCE_MIDAIR = 10.0

var TIME_CONTROL_MULTIPLIER : float = 1.0
@export var speed_map : Dictionary[GameManager.TimeControl, float] = {
	GameManager.TimeControl.NORMAL : 1.0,
	GameManager.TimeControl.FAST : 2.0,
	GameManager.TimeControl.FASTEST : 3.0
}

func handle_time_control_changed(new_time_control : GameManager.TimeControl):
	TIME_CONTROL_MULTIPLIER = speed_map[new_time_control]
	
@onready var _animated_head_sprite = $AnimatedHeadSprite
@onready var _animated_body_sprite = $AnimatedBodySprite

func _ready() -> void:
	_animated_head_sprite.play("default")
	GameManager.time_control_changed.connect(handle_time_control_changed)

func _physics_process(delta: float):
	#always apply gravity, unconditional of any user input or horizontal momentum.a
	velocity.y += GRAVITY * delta * TIME_CONTROL_MULTIPLIER
	
	var IsOnFloor = is_on_floor()
	var IsInMidair = get_slide_collision_count() == 0
	if Input.is_action_just_pressed("jump"):
		if IsOnFloor: #also need a check for if the player is on the floor.
			velocity.y = -1 * JUMP_FORCE_Y * sqrt(TIME_CONTROL_MULTIPLIER)
		elif is_on_wall():
			velocity.x = get_collided_wall_normal().x * JUMP_FORCE_X * TIME_CONTROL_MULTIPLIER
			velocity.y = -1 * JUMP_FORCE_Y_WALL * sqrt(TIME_CONTROL_MULTIPLIER)
			debug_evaluate_collisions()
			return
			
	var target_velocity = 0.0
	var direction_change_force = TIME_CONTROL_MULTIPLIER
	if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		target_velocity = RUN_SPEED * TIME_CONTROL_MULTIPLIER
		
		if Input.is_action_pressed("move_left"):
			target_velocity *= -1
		if IsOnFloor:
			direction_change_force *= DIRECTION_CHANGE_FORCE_FLOOR
		elif IsInMidair: # player character is midair
			direction_change_force *= DIRECTION_CHANGE_FORCE_MIDAIR
	else:
		if IsOnFloor:
			direction_change_force *= TO_STANDSTILL_FORCE_FLOOR
		elif IsInMidair:
			direction_change_force *= TO_STANDSTILL_FORCE_MIDAIR
	
	
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
	
	if Input.is_action_pressed("jump") || !is_on_floor():
		_animated_body_sprite.play("jump")
	elif Input.is_action_pressed("move_left"):
		_animated_body_sprite.play("running")
		_animated_body_sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		_animated_body_sprite.play("running")
		_animated_body_sprite.flip_h = false
	else:
		_animated_body_sprite.play("default")
	
func debug_evaluate_collisions():
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		continue
