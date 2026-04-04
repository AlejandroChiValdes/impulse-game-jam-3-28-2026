extends Node2D
# maintains in-game timer. Functionality includes:
# 1. Listen for first player input and start timer
@export var PlayerCharacter : CharacterBody2D
# 2. (stretch) Pause timer when pause menu is opened
# 3. Listen for end state and stop timer.

var GAME_TIME : float = 0.0
var IS_TRACKING_TIME : bool = false

signal game_timer_updated(new_time : float)

func _ready():
	PlayerCharacter.player_started_moving.connect(_on_player_started_moving)
	
func _on_player_started_moving():
	#begin timer
	IS_TRACKING_TIME = true

func _process(delta: float):
	if IS_TRACKING_TIME:
		GAME_TIME += delta
		game_timer_updated.emit(GAME_TIME)
