extends Node2D

signal flag_area_entered
signal flag_area_exited

@onready var animated_sprite = $AnimatedSprite2D
@onready var button_texture = $AnimatedSprite2D/TextureRect
@onready var e_texture = preload("res://assets/stage/ui/E.png")
@onready var e_texture_hover = preload("res://assets/stage/ui/E Ditekan.png")

var is_completed: bool = false

func _ready() -> void:
	animated_sprite.play("idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('submit') and is_completed and button_texture.visible:
		change_e_texture(true)
		await get_tree().create_timer(0.3).timeout
		get_tree().change_scene_to_file("res://scenes/stages/4/stage_4.tscn")

func _on_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_completed:
		button_texture.show()

func play_animation(frame: String):
	animated_sprite.play(frame)

func change_e_texture(is_hover: bool):
	if is_hover:
		button_texture.texture = e_texture_hover
	else:
		button_texture.texture = e_texture

func _on_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		button_texture.hide()
