extends Node2D

signal flag_area_entered(can_move, node_name)
signal flag_area_exited
signal flag_exit_screen

@onready var animated_sprite = $AnimatedSprite2D
@onready var button_texture = $AnimatedSprite2D/TextureRect
@onready var e_texture = preload("res://assets/stage/button/E.png")
@onready var e_texture_hover = preload("res://assets/stage/button/E Ditekan.png")

var is_completed: bool = false

func _ready() -> void:
	animated_sprite.play("idle")

func _on_area_body_entered(body: Node2D) -> void:
	if body.name == "FlagPlayer" and is_completed:
		button_texture.show()

func play_animation(frame: String):
	animated_sprite.play(frame)

func change_e_texture(is_hover: bool):
	if is_hover:
		button_texture.texture = e_texture_hover
	else:
		button_texture.texture = e_texture

func _on_area_body_exited(body: Node2D) -> void:
	if body.name == "FlagPlayer":
		button_texture.hide()
