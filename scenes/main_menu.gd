extends Control

@onready var play: TextureButton = $VBoxContainer/Play
@onready var options: TextureButton = $VBoxContainer/Options
@onready var exit: TextureButton = $VBoxContainer/Exit
@onready var options_menu: Control = $OptionsMenu
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var back: Button = $OptionsMenu/Panel/Back
@onready var master_volume: HSlider = $OptionsMenu/Panel/VBoxContainer/MasterVolume/HSlider
@onready var music_volume: HSlider = $OptionsMenu/Panel/VBoxContainer/MusicVolume/HSlider
@onready var option_button: OptionButton = $OptionsMenu/Panel/VBoxContainer/Resolution/OptionButton
@onready var check_box: CheckBox = $OptionsMenu/Panel/VBoxContainer/Fullscreen/CheckBox

const MASTER_BUS_IDX = 0
const MUSIC_BUS_IDX = 1

func _ready():
	$AnimationPlayer.play("wobble")
	#AudioController.play_music()
	play.button_down.connect(on_play_pressed)
	options.button_down.connect(on_options_pressed)
	exit.button_down.connect(on_exit_pressed)
	back.button_down.connect(on_options_back_pressed)
	master_volume.value_changed.connect(_on_master_volume_changed)
	music_volume.value_changed.connect(_on_music_volume_changed)
	option_button.item_selected.connect(_on_resoluton_selected)
	check_box.toggled.connect(_on_fullscreen_pressed)
	# Initialize volume sliders
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS_IDX))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_IDX))

func on_options_pressed() -> void:
	#AudioController.play_click()
	options_menu.visible = true
	v_box_container.visible = false
	pass
	
func on_options_back_pressed() -> void:
	#AudioController.play_click()
	options_menu.visible = false
	v_box_container.visible = true
	pass
	
func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_BUS_IDX, linear_to_db(value))

func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_IDX, linear_to_db(value))
	
func _on_fullscreen_pressed(toggled_on: bool):
	#AudioController.play_click()
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	print(DisplayServer.window_get_mode())
	
func _on_resoluton_selected(index):
	#AudioController.play_click()
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
	print(DisplayServer.window_get_size())
	
func on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/1/world.tscn")
		
func on_exit_pressed() -> void:
	#AudioController.play_click()
	get_tree().quit()

#func _on_yes_pressed() -> void:
	#AudioController.play_click()
	#SceneTransition.change_scene("res://scenes/tutorial/starter_experiences/starter_experiences_tutorial.tscn")

#func _on_no_pressed() -> void:
	#AudioController.play_click()
	#SceneTransition.change_scene("res://scenes/starter_experiences/starter_experiences.tscn")

func _on_close_button_pressed() -> void:
	$PopUp.hide()
