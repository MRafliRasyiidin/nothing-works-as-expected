extends Control

@onready var player_finish: Node2D = $PlayerFinish
@onready var player_animation: AnimatedSprite2D = $PlayerFinish/AnimatedSprite2D
@onready var flag_player: CharacterBody2D = $FlagPlayer
@onready var health_bar_rigid: RigidBody2D = $RigidBody2D
@onready var player_finish_texture: TextureRect = $PlayerFinish/AnimatedSprite2D/TextureRect
@onready var hint = $StageIntro

var is_completed: bool = false

func _ready() -> void:
	if GameState.is_start_stage:
		await $Transition.finished
		$Transition.hide()
		GameState.is_intro = true
		hint.set_label('You can finish the stage when the timer runs out!')
		hint.show()
		await get_tree().create_timer(3).timeout
		hint.hide()
		GameState.is_intro = false
		GameState.is_start_stage = false
	
	player_animation.play("idle")
	flag_player.play_animation("idle")
	health_bar_rigid.timer_empty.connect(_on_timer_empty)
	
func _on_timer_empty():
	is_completed = true
	player_finish.is_completed = true
