extends Control

@onready var wall_sprite: Sprite2D = $Wall/Sprite2D
@onready var wall_col: CollisionShape2D = $Wall/CollisionShape2D

var player_in_flag_area: bool = false
@onready var e: TextureRect = $Flag/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp_count = min(GameState.retry_count, wall_sprite.hframes - 1)
	wall_sprite.frame = temp_count
	print(wall_sprite.frame, temp_count)
	
	if temp_count == wall_sprite.hframes - 1:
		wall_sprite.hide()
		wall_col.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('submit') and player_in_flag_area:
		await get_tree().create_timer(0.3).timeout
		get_tree().change_scene_to_file("res://scenes/stages/5/stage_5.tscn")

func _on_retry_pressed() -> void:
	GameState.retry_count += 1
	print("Retried %dx" % [GameState.retry_count])
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_flag_area = true
		e.show()
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_flag_area = false
		e.hide()
	pass # Replace with function body.
