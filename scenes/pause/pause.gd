extends Control

@onready var options: Control = $MarginContainer/OptionsMenu
@onready var main: VBoxContainer = $MarginContainer/Main

func _ready() -> void:
	get_tree().paused = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused: 
			self.show()
			print("Game paused")
		else: 
			self.hide()
			print("Game resumed")

func _on_resume_pressed() -> void:
	get_tree().paused = false
	self.hide()
	print("Game resumed")
	pass # Replace with function body.


func _on_options_pressed() -> void:
	main.hide()
	options.show()
	
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func back_from_settings() -> void:
	main.show()
	print("Backed from settings")
