extends Node3D

@onready var stage = $SubViewport/Stages1
@onready var hint = $SubViewport/StageIntro
@onready var transition = $SubViewport/VideoStreamPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if GameState.is_start_stage:
		transition.show()
		await transition.finished
		transition.hide()
		GameState.is_intro = true
		hint.show()
		await get_tree().create_timer(4).timeout
		hint.hide()
		GameState.is_intro = false
		GameState.is_start_stage = false

func _input(event: InputEvent) -> void:
	if not GameState.is_intro:
		if event.is_action_pressed("move_hand") or event.is_action_released("move_hand"):
			stage._input(event)
		if event.is_action_pressed("submit"):
			stage._input(event)
