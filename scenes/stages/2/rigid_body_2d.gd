extends RigidBody2D

@onready var bar: TextureProgressBar = $TextureProgressBar
var still_contact = false
var pushing_body: Node2D = null
var push_speed := 15
var is_decrease: bool = false

signal timer_empty

func _physics_process(delta):
	if not GameState.is_intro and not GameState.is_start_stage:
		if still_contact and pushing_body and GameState.is_player_move:
			var dir = pushing_body.global_position.x - global_position.x
			
			if dir > 0:
				print("Didorong dari kanan")
				print(push_speed * delta)
				bar.value -= push_speed * delta
			else:
				print("Didorong dari kiri")
				bar.value += push_speed * delta

			bar.value = clamp(bar.value, bar.min_value, bar.max_value)
		else:
			if bar.value != 0:
				if bar.value >= 100:
					is_decrease = true
				if bar.value <= 40:
					is_decrease = false
					
				if is_decrease:
					bar.value -= 0.2
					bar.value = clamp(bar.value, bar.min_value, bar.max_value)
				else:
					bar.value += 0.2
					bar.value = clamp(bar.value, bar.min_value, bar.max_value)

func _on_area_2d_body_entered(body):
	if body.name == "FlagPlayer":
		still_contact = true
		pushing_body = body

func _on_area_2d_body_exited(body):
	if body == pushing_body:
		still_contact = false
		pushing_body = null

func _on_texture_progress_bar_value_changed(value: float) -> void:
	if bar.value == 0:
		emit_signal("timer_empty")
