extends Node2D

signal flag_area_entered(can_move, node_name)
signal flag_area_exited
signal flag_exit_screen

@onready var animated_sprite = $AnimatedSprite2D
@onready var button_texture = $AnimatedSprite2D/TextureRect
@onready var e_texture = preload("res://assets/stage/ui/E.png")
@onready var e_texture_hover = preload("res://assets/stage/ui/E Ditekan.png")

var can_move: bool = false
var is_completed: bool = false

func _ready() -> void:
	animated_sprite.play("idle")

func _on_area_body_entered(body: Node2D) -> void:
	flag_area_entered.emit(can_move, body.name)
	if body.name == "Player":
		can_move = false
		is_completed = true
	if body.name == "Player" and not can_move and animated_sprite.animation != 'run':
		button_texture.show()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	flag_exit_screen.emit()

func play_animation(frame: String):
	animated_sprite.play(frame)

func change_e_texture(is_hover: bool):
	if is_hover:
		button_texture.texture = e_texture_hover
	else:
		button_texture.texture = e_texture

func _on_area_body_exited(body: Node2D) -> void:
	if body.name == "Player" and not can_move:
		button_texture.hide()
