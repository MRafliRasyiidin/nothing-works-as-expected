extends Control

#@onready var camera: Camera2D = $Camera2D
@onready var flag: Node2D = $Flag/Flag
var is_flag_in_frame: bool = false
var is_item_in_frame: bool = false

func _process(delta: float) -> void:
	if is_flag_in_frame and is_item_in_frame:
		flag.is_completed = true
	else:
		flag.is_completed = false

func _on_visible_flag_screen_entered() -> void:
	is_flag_in_frame = true

func _on_visible_item_screen_entered() -> void:
	is_item_in_frame = true

func _on_visible_item_screen_exited() -> void:
	is_item_in_frame = false

func _on_visible_flag_screen_exited() -> void:
	is_flag_in_frame = false
