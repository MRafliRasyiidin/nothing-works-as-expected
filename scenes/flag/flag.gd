extends Node2D

signal flag_area_entered(can_move, node_name)
signal flag_area_exited

var can_move: bool = false

func _on_area_body_entered(body: Node2D) -> void:
	flag_area_entered.emit(can_move, body.name)
