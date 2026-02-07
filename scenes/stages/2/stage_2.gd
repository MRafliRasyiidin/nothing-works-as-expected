extends Control

@onready var player_finish: Node2D = $PlayerFinish
@onready var player_animation: AnimatedSprite2D = $PlayerFinish/AnimatedSprite2D
@onready var flag_player: CharacterBody2D = $FlagPlayer
@onready var health_bar_rigid: RigidBody2D = $RigidBody2D
@onready var player_finish_texture: TextureRect = $PlayerFinish/AnimatedSprite2D/TextureRect
var is_completed: bool = false

func _ready() -> void:
	player_animation.play("idle")
	flag_player.play_animation("idle")
	health_bar_rigid.timer_empty.connect(_on_timer_empty)
	
func _on_timer_empty():
	is_completed = true
	player_finish.is_completed = true
