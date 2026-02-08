extends Control

@onready var stage: Label = $VBoxContainer/Stage
@onready var hint: Label = $VBoxContainer/Hint
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var hints := {
	1: "Capture the Flag",
	2: "Finish When The Time Comes",
	3: "A Flag Is Nothing Without X",
	4: "Go Back In Time",
	5: "She wants something...",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage.text = "Stage %d" % [GameState.current_stage]
	hint.text = hints[GameState.current_stage]
	#print(GameState.current_stage)
	anim.stop()
	await timer.timeout
	anim.play("fade")
	timer.start()
	await timer.timeout
	anim.play_backwards("fade")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	print("test")
	pass # Replace with function body.
