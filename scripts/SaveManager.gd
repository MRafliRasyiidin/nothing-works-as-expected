extends Node

const save_location = "user://savefile.save"

func save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(GameState.global_leaderboard.duplicate())
	file.close()
	
func load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data: Array = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		GameState.global_leaderboard = save_data
