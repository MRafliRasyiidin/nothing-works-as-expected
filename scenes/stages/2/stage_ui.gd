extends Control

@onready var pause_popup = $Control
@onready var options_menu = $Control/OptionsMenu
@onready var check_box = $Control/OptionsMenu/Panel/VBoxContainer/Fullscreen/CheckBox

func _ready() -> void:
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
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

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
	pass # Replace with function body.
