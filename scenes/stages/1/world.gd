extends Node3D

@onready var stage = $SubViewport/Stages1
@onready var hint = $SubViewport/StageIntro
@onready var transition = $SubViewport/VideoStreamPlayer

func _ready() -> void:
	if GameState.is_start_stage:
		await transition.finished
		transition.hide()
		GameState.is_intro = true
		hint.set_label('Easy, just reach the flag!')
		hint.show()
		await get_tree().create_timer(3).timeout
		hint.hide()
		GameState.is_intro = false
		GameState.is_start_stage = false

func _input(event: InputEvent) -> void:
	if not GameState.is_intro:
		if event.is_action_pressed("move_hand"):
			stage._input(event)
		if event.is_action_pressed("submit") or event.is_action_pressed("move_hand"):
			stage._input(event)
