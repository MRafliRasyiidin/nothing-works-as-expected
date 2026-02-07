extends Control

@onready var flag: Node2D = $Flag
#@onready var hand: TextureRect = $Hand
@onready var hand: Sprite2D = $Hand/Sprite2D
@onready var player: CharacterBody2D = $Player
@onready var collision = $HealthBar/RigidBody2D/CollisionShape2D
var distance_threshold = 100

func _ready() -> void:
	flag.flag_area_entered.connect(_on_flag_area_entered)
	flag.can_move = true

func _on_flag_area_entered(can_move: bool, node_name: String):
	if can_move:
		if node_name == "Player":
			random_flag_position()
	else:
		var hand_origin_pos = hand.global_position
		var player_pos = player.global_position
		hand.global_position = player_pos

func random_flag_position():
	var rand_x = randf_range(200, get_viewport().size.x-200)
	var rand_y = randf_range(200, get_viewport().size.y-200)
	var new_pos = Vector2(rand_x, rand_y)
	
	while new_pos.distance_squared_to(player.global_position) <= distance_threshold:
		rand_x = randf_range(200, get_viewport().size.x-200)
		rand_y = randf_range(200, get_viewport().size.y-200)
		new_pos = Vector2(rand_x, rand_y)
	
	print(new_pos)
	var tween: Tween = create_tween()
	tween.tween_property(flag, "global_position", new_pos, 0.5)
