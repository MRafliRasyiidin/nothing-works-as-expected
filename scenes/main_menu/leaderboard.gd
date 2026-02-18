extends Control

@onready var leaderboard_container: VBoxContainer = $TextureRect/ScrollContainer/VBoxContainer
@onready var leaderboard_row: PackedScene = preload("res://scenes/main_menu/leaderboard_row.tscn")

func _ready():
	var leaderboard_data = GameState.global_leaderboard.duplicate()
	leaderboard_data.sort_custom(func(a, b):
		return a["time"]["total"] < b["time"]["total"]
	)
	
	for i in range(len(leaderboard_data)):
		var row = leaderboard_row.instantiate()
		leaderboard_container.add_child(row)
		row.set_data(
			str(i + 1),
			leaderboard_data[i]["name"],
			str(leaderboard_data[i]["time"]["total"])
		)
