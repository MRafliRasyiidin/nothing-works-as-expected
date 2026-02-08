extends Node

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

var is_hand_attacking = false
var is_player_move = false

var retry_count = 0

var current_stage = 1
