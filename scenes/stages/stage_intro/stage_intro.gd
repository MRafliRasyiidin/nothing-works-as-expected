extends Control

@onready var label = $Label

func set_label(text: String):
	label.text = text
