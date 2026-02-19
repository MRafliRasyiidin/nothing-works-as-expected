extends Control

@onready var pause_popup = $Control
@onready var options_menu = $Control/OptionsMenu
@onready var check_box = $Control/OptionsMenu/Panel/VBoxContainer/Fullscreen/CheckBox
@onready var hint: Control = $Hint
@onready var hint_text: Label = $Hint/MarginContainer/HintText
@onready var timer: Timer = $Timer

var current_hint: int = 1

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	check_box.toggled.connect(_on_fullscreen_pressed)
	check_box.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

func _on_pause_button_pressed() -> void:
	pause_popup.show()
	get_tree().paused = true

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	pause_popup.hide()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_settings_pressed() -> void:
	options_menu.show()
	
func _on_fullscreen_pressed(toggled_on: bool):
	print('ayay')
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
	var hint_list = GameState.hints[GameState.current_stage]
	var concated_hint = ""
	for i in range(current_hint):
		concated_hint += str(i+1) + ". " + hint_list[i] + "\n"
	hint_text.text = concated_hint
	hint.show()

func _on_back_hint_pressed() -> void:
	hint.hide()

func _on_timer_timeout():
	if current_hint < len(GameState.hints[GameState.current_stage]):
		current_hint += 1
	print(current_hint)
	print('aYAYAYAYA')
