extends Control

@onready var number_label: Label = $TextureButton/HBoxContainer/Number
@onready var player_name_label: Label = $TextureButton/HBoxContainer/Name
@onready var time_label: Label = $TextureButton/HBoxContainer/Time

func set_data(number: String, player_name: String, time: String):
	print(number_label, player_name_label, time_label)
	number_label.text = number
	player_name_label.text = player_name
	time_label.text = time
