extends CharacterBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var GOD_MODE = 0
var GOD_MODE_SPEED_MULT = 3
@export var JUMP_FORCE_Y = 50.0
@export var JUMP_FORCE_Y_WALL = 50.0
@export var JUMP_FORCE_X = 500.0
@export var RUN_SPEED = 200.0
@export var DIRECTION_CHANGE_FORCE_FLOOR = 5.0
@export var DIRECTION_CHANGE_FORCE_MIDAIR = 10.0
@export var TO_STANDSTILL_FORCE_FLOOR = 10.0
@export var TO_STANDSTILL_FORCE_MIDAIR = 10.0

@onready var smoke_fx: AnimatedSprite2D = $TimeSmokeFX
@onready var time_light_fx: AnimatedSprite2D = $TimeLightFX
@onready var head_color: AnimatedSprite2D = $AnimatedHeadSprite/HeadColor
@export var head_color_map: Dictionary[GameManager.TimeControl, Color]

var TIME_CONTROL_MULTIPLIER : float = 1.0
@export var speed_map : Dictionary[GameManager.TimeControl, float] = {
	GameManager.TimeControl.NORMAL : 1.0,
	GameManager.TimeControl.FAST : 2.0,
	GameManager.TimeControl.FASTEST : 3.0
}

#Used to kick off in-game timer
var has_player_moved : bool = false
signal player_started_moving

func handle_time_control_changed(new_time_control : GameManager.TimeControl):
	if smoke_fx.is_playing() or time_light_fx.is_playing():
		smoke_fx.stop()
		time_light_fx.stop()

	smoke_fx.play("default")
	time_light_fx.play("default")
	head_color.self_modulate = head_color_map[new_time_control]
	head_color.play("default")

	TIME_CONTROL_MULTIPLIER = speed_map[new_time_control]
	_animated_head_sprite.set_speed_scale(speed_map[new_time_control])
	
@onready var _animated_head_sprite = $AnimatedHeadSprite
@onready var _animated_body_sprite = $AnimatedBodySprite

func _ready() -> void:
	_animated_head_sprite.play("default")
	GameManager.time_control_changed.connect(handle_time_control_changed)

#Initialize at INT_MAX and replace at player's first jump input.
var INT_MAX = 9223372036854775806
var FRAMES_SINCE_JUMPED = INT_MAX
@export var INPUT_BUFFER_FRAMES = 15
var HAS_BURNED_WALL_JUMP : bool = false
func _physics_process(delta: float):
	#always apply gravity, unconditional of any user input or horizontal momentum.a
	velocity.y += GRAVITY * delta * TIME_CONTROL_MULTIPLIER * float(!GOD_MODE)
	
	var IsOnFloor = is_on_floor()
	var IsInMidair = get_slide_collision_count() == 0
	var TimeControlForceMultiplier = sqrt(TIME_CONTROL_MULTIPLIER)
	
	if IsOnFloor && HAS_BURNED_WALL_JUMP:
		HAS_BURNED_WALL_JUMP = false
	update_input_buffer_values()
	var DidJump = false
	if Input.is_action_just_pressed("jump") || FRAMES_SINCE_JUMPED <= INPUT_BUFFER_FRAMES:
		print("Frames since jumped: ", FRAMES_SINCE_JUMPED)
		print("INPUT_BUFFER_FRAMES: ", INPUT_BUFFER_FRAMES)
		if IsOnFloor:
			velocity.y = -1 * JUMP_FORCE_Y * TimeControlForceMultiplier
			DidJump = true
		elif is_on_wall() && !HAS_BURNED_WALL_JUMP:
			velocity.x = get_collided_wall_normal().x * JUMP_FORCE_X * TimeControlForceMultiplier
			velocity.y = -1 * JUMP_FORCE_Y_WALL * TimeControlForceMultiplier
			HAS_BURNED_WALL_JUMP = true
			DidJump = true
	if DidJump:
		FRAMES_SINCE_JUMPED = INT_MAX
			
	var target_velocity = 0.0
	var direction_change_force = TimeControlForceMultiplier
	if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		target_velocity = RUN_SPEED * TimeControlForceMultiplier * get_god_mode_speed_mult(GOD_MODE)
		if Input.is_action_pressed("move_left"):
			target_velocity *= -1
		if IsOnFloor:
			direction_change_force *= DIRECTION_CHANGE_FORCE_FLOOR * TimeControlForceMultiplier
		elif IsInMidair: # player character is midair
			direction_change_force *= DIRECTION_CHANGE_FORCE_MIDAIR * TimeControlForceMultiplier
	else: #Player isn't inputting any keyboard inputs
		if IsOnFloor:
			direction_change_force *= TO_STANDSTILL_FORCE_FLOOR * TimeControlForceMultiplier
		elif IsInMidair:
			direction_change_force *= TO_STANDSTILL_FORCE_MIDAIR * TimeControlForceMultiplier
	
	
	velocity.x = move_toward(velocity.x, target_velocity, direction_change_force)
	move_and_slide()
	
func update_input_buffer_values():
	if Input.is_action_just_pressed("jump"):
		FRAMES_SINCE_JUMPED = 0
	else:
		FRAMES_SINCE_JUMPED = min(FRAMES_SINCE_JUMPED + 1, INT_MAX)

func get_collided_wall_normal():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		return collision.get_normal()

var IS_RUNNING = false
var POPPED_JUMPING_HEAD = false
var POPPED_JUMPING_HEAD_MAGNITUDE = 0.0
func _process(delta: float):
	#Note: May need to make a custom function to check if any "movement" inputs have been pressed,
	#as currently any single mouse movement or keystroke will start the timer.
	if !has_player_moved && is_movement_input_pressed():
		player_started_moving.emit()
		has_player_moved = true
	# God Mode toggles collision and physics
	if Input.is_action_just_pressed("God Mode"):
		GOD_MODE = !GOD_MODE
		get_node("CollisionShape2D").disabled = !get_node("CollisionShape2D").disabled
			
	if(GOD_MODE):
		if Input.is_action_pressed("move_up"):
			velocity.y = -64 * TIME_CONTROL_MULTIPLIER
		elif Input.is_action_pressed("move_down"):
			velocity.y = 64 * TIME_CONTROL_MULTIPLIER
	
	if Input.is_action_just_pressed("time_shift_down"):
		GameManager.time_control_slow_down.emit()
	elif Input.is_action_just_pressed("time_shift_up"):
		GameManager.time_control_speed_up.emit()
		return
	
	if Input.is_action_just_pressed("jump") && is_on_wall():
		_animated_head_sprite.set_position(_animated_head_sprite.position + Vector2(0, -1))
		POPPED_JUMPING_HEAD_MAGNITUDE += 1
		POPPED_JUMPING_HEAD = true
	elif !is_on_floor() && !POPPED_JUMPING_HEAD:
		_animated_head_sprite.set_position(_animated_head_sprite.position + Vector2(0, -1))
		POPPED_JUMPING_HEAD_MAGNITUDE += 1
		POPPED_JUMPING_HEAD = true
	elif is_on_floor() && POPPED_JUMPING_HEAD:
		_animated_head_sprite.set_position(_animated_head_sprite.position + Vector2(0, POPPED_JUMPING_HEAD_MAGNITUDE))
		POPPED_JUMPING_HEAD_MAGNITUDE = 0.0
		POPPED_JUMPING_HEAD = false
		
	#Ensures the head is attached to the body during the player's run animation.
	if (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")) && is_on_floor():
		if IS_RUNNING == false:
			_animated_head_sprite.set_position(_animated_head_sprite.position + Vector2(0, 2))
			IS_RUNNING = true
	elif IS_RUNNING:
		#_animated_head_sprite.set_offset(Vector2(0, -1.5))
		_animated_head_sprite.set_position(_animated_head_sprite.position + Vector2(0, -2))
		IS_RUNNING = false
	
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

func is_movement_input_pressed():
	return Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("jump")
	
func debug_evaluate_collisions():
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		continue
		
func get_god_mode_speed_mult(is_god_mode: bool):
	if(is_god_mode):
		return GOD_MODE_SPEED_MULT
	else:
		return 1
