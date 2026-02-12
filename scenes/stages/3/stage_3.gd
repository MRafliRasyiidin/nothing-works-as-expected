extends Control

@onready var camera: Camera2D = $RigidBody2D/Camera2D
@onready var flag: Node2D = $Flag/Flag
@onready var hint: Control = $StageIntro
@onready var stage_ui = $StageUI
@onready var transition: VideoStreamPlayer = $Transition
@onready var e_texture: Sprite2D = $Node2D/Sprite2D

var is_flag_in_frame: bool = false
var is_item_in_frame: bool = false

func _ready() -> void:
	var path = get_tree().current_scene.scene_file_path
	var file_name = path.get_file().get_basename()
	var parts = file_name.split("_")
	var stage_number = int(parts[1])
	
	GameState.current_stage = stage_number
	hint.set_stage(stage_number)
	if GameState.is_start_stage:
		await show_video()
		await show_hint()
		GameState.is_start_stage = false

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

func show_hint():
	var viewport_size = get_viewport_rect().size
	var zoom = camera.zoom
	
	var camera_size = viewport_size / zoom
	
	print("Camera visible size:", camera_size)
	
	hint.global_position = camera.global_position
	GameState.is_intro = true
	hint.show()
	await get_tree().create_timer(3).timeout
	hint.hide()
	GameState.is_intro = false
	
func show_video():
	transition.show()
	var viewport_size = get_viewport_rect().size
	var zoom = camera.zoom
	var camera_size = viewport_size / zoom
	print("Camera visible size:", camera_size)
	transition.global_position = camera.global_position-(camera_size/2 + Vector2(0, 1))
	GameState.is_intro = true
	GameState.is_intro = false
	await transition.finished
	transition.hide()
