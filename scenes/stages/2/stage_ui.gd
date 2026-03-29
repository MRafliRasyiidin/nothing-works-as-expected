extends Control

@onready var pause_popup = $Control
@onready var options_menu = $Control/OptionsMenu
@onready var check_box = $Control/OptionsMenu/Panel/VBoxContainer/Fullscreen/CheckBox
@onready var hint: Control = $Hint
@onready var hint_text: Label = $Hint/MarginContainer/HintText
@onready var timer: Timer = $Timer

@onready var stage: Label = $StageIntro/VBoxContainer/Stage
@onready var hint_anim_label: Label = $StageIntro/VBoxContainer/Hint
@onready var anim: AnimationPlayer = $StageIntro/AnimationPlayer
@onready var timer_anim: Timer = $StageIntro/Timer

signal move_right

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	check_box.toggled.connect(_on_fullscreen_pressed)
	check_box.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	timer.start(45)

func _on_pause_button_pressed() -> void:
	pause_popup.show()
	get_tree().paused = true

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	pause_popup.hide()
	if GameState.disable_move:
		emit_signal("move_right")

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_settings_pressed() -> void:
	options_menu.show()
	
func _on_fullscreen_pressed(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	print(DisplayServer.window_get_mode())
#func _on_master_volume_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(MASTER_BUS_IDX, linear_to_db(value))
#
#func _on_music_volume_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(MUSIC_BUS_IDX, linear_to_db(value))

func _on_back_pressed() -> void:
	options_menu.hide()

func _on_hint_button_pressed() -> void:
	get_tree().paused = true
	var hint_list = GameState.hints[GameState.current_stage]
	var concated_hint = ""
	for i in range(GameState.current_hint):
		concated_hint += str(i+1) + ". " + hint_list[i] + "\n"
	hint_text.text = concated_hint
	hint.show()

func _on_back_hint_pressed() -> void:
	get_tree().paused = false
	hint.hide()

func _on_timer_timeout():
	if GameState.current_hint < len(GameState.hints[GameState.current_stage]):
		GameState.current_hint += 1
		await display_new_hint()
	
func display_new_hint():
	$StageIntro.show()
	stage.text = "New Hint"
	hint_anim_label.text = GameState.hints[GameState.current_stage][GameState.current_hint-1]
	anim.stop()
	get_tree().paused = true
	anim.play("fade")
	timer_anim.start()
	await timer_anim.timeout
	anim.play_backwards("fade")
	$StageIntro.hide()
	get_tree().paused = false
