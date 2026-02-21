extends Control

@onready var line_edit: LineEdit = $VBoxContainer/LineEdit
@onready var submit_button: TextureButton = $Submit
@onready var exit_button: TextureButton = $Exit

func _ready():
	line_edit.grab_focus()
	submit_button.pressed.connect(Callable(self, "_on_submit_pressed"))
	exit_button.pressed.connect(Callable(self, "_on_exit_pressed"))
	
func _on_submit_pressed():
	if not line_edit.text.strip_edges().is_empty():
		GameState.player_name = line_edit.text
		GameState.add_to_leaderboard()
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	else:
		pass
	
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
