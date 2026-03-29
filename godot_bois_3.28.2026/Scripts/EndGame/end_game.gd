extends Area2D

@export var game_over_ui: Control

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().paused = true
		game_over_ui.visible = true
