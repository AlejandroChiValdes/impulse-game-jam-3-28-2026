extends Node2D
@onready var _animated_head_sprite = $AnimatedHeadSprite
@onready var _animated_body_sprite = $AnimatedBodySprite

func _ready():
	_animated_head_sprite.play("default")
