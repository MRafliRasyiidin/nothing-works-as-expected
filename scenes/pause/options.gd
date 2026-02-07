extends Control

@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Music/HSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SFX/HSlider

var sfx_bus = AudioServer.get_bus_index("SFX")
var music_bus = AudioServer.get_bus_index("Music")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_slider.value = db_to_linear(music_bus)
	sfx_slider.value = db_to_linear(sfx_bus)


func _on_back_pressed() -> void:
	if get_parent().get_parent():
		get_parent().get_parent().back_from_settings()
	self.hide()
	pass # Replace with function body.


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_slider.value))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_slider.value))
	print("Music: ", db_to_linear(AudioServer.get_bus_volume_linear(music_bus)))
	print("SFX: ", db_to_linear(AudioServer.get_bus_volume_linear(sfx_bus)))
