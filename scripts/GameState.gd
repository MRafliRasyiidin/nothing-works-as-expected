extends Node

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	SaveManager.load()
	print(global_leaderboard)

var is_hand_attacking = false
var is_player_move = false
var is_intro: bool = false
var is_start_stage: bool = true

var retry_count = 0
var start_time: int = 0

var current_stage = 1
var total_stage = 6

var player_name: String = ""

var stage_finish_time = {
	"1": 0,
	"2": 0,
	"3": 0,
	"4": 0,
	"5": 0,
	"6": 0,
	"total": 0,
}

var global_leaderboard = [
	
]

func reset_global_var():
	is_hand_attacking = false
	is_player_move = false
	is_intro = false
	is_start_stage = true
	retry_count = 0
	current_stage = 1
	stage_finish_time = {
		"1": 0,
		"2": 0,
		"3": 0,
		"4": 0,
		"5": 0,
		"6": 0,
		"total": 0,
	}

func add_to_leaderboard():
	var sum = 0
	for i in range(1, total_stage+1):
		sum += stage_finish_time[str(i)]
	stage_finish_time["total"] = sum
	global_leaderboard.append(
		{
			"name": player_name,
			"time": stage_finish_time.duplicate()
		}
	)
	SaveManager.save()
	
# Time already in second
func add_stage_time(stage: String, time: float):
	stage_finish_time.set(stage, time)
	stage_finish_time["total"] += time
	print(stage_finish_time)
