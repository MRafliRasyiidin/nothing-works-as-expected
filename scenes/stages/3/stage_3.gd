extends Control

@onready var camera: Camera2D = $Camera2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		camera.global_position.x += 10
