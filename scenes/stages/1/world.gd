extends Node3D

@onready var stage = $SubViewport/Stages1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_hand"):
		stage._input(event)
	if event.is_action_pressed("submit") or event.is_action_pressed("move_hand"):
		stage._input(event)
