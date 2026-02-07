extends Node2D

@onready var canvas: CanvasLayer = $CanvasLayer
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

#func _ready() -> void:
	#canvas.show()
	#animation_player.play('fade_out')

func play(animation: String):
	print(animation)
	canvas.show()
	animation_player.play(animation)
	await animation_player.animation_finished
