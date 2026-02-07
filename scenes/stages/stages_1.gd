extends Control

signal dead

@onready var flag: Node2D = $Flag
@onready var hand: RigidBody2D = $Hand
@onready var player: CharacterBody2D = $Player
@onready var collision = $HealthBar/RigidBody2D/CollisionShape2D
@onready var hand_collision = $Hand/CollisionShape2D
@onready var health_object = $HealthObject
@onready var fade_effect = $Fade
@onready var hand_sprite = $Hand/Sprite2D
@onready var blocking_hand_texture = preload("res://assets/hand/nampar.png")
@onready var normal_hand_texture = preload("res://assets/hand/regular state.png")

var distance_threshold = 100
var flag_tween: Tween
var can_hand_move = true
var can_hand_controlled = true
var hand_attacking = false

func _ready() -> void:
	dead.connect(_on_restart)
	flag.flag_area_entered.connect(_on_flag_area_entered)
	flag.flag_exit_screen.connect(_on_flag_exit_screen)
	#player.get_hitted.connect(_on_player_get_hitted)
	flag.can_move = true

func _input(event: InputEvent) -> void:
	if can_hand_move and can_hand_controlled:
		if event.is_action_pressed("move_hand"):
			can_hand_move = false
			GameState.is_hand_attacking = true
			move_hand()
	if event.is_action_pressed("submit"):
		if flag.is_completed:
			flag.change_e_texture(true)
			await get_tree().create_timer(0.2).timeout
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_flag_area_entered(can_move: bool, node_name: String):
	if can_move:
		if node_name == "Player":
			random_flag_position()
	if node_name == "Hand":
		if flag_tween:
			flag_tween.kill()
			can_hand_controlled = false
			flag.play_animation('idle')

func random_flag_position():
	flag.play_animation('run')
	var new_pos = Vector2(5000, -1000)
	if flag_tween:
		flag_tween.kill()
	flag_tween = create_tween()
	flag_tween.tween_property(flag, "global_position", new_pos, 15)

func _on_restart():
	await fade_effect.play("fade_out")
	get_tree().reload_current_scene()
	await fade_effect.play("fade_in")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('exit lol')

func _on_flag_exit_screen():
	await get_tree().create_timer(2).timeout
	await fade_effect.play("fade_out")
	get_tree().reload_current_scene()
	await fade_effect.play("fade_in")

func move_hand():
	hand_sprite.texture = blocking_hand_texture
	var origin = hand.global_position
	var target_y = 450

	hand.gravity_scale = -10

	while hand.global_position.y > target_y:
		await get_tree().physics_frame

	hand.gravity_scale = 10

	hand.gravity_scale = 0

#func attack_player():
	#hand_attacking = true
	#var origin = hand.global_position
	#var target = player.global_position
	#var speed = 2000
#
	#hand.gravity_scale = 0
	#hand.linear_velocity = Vector2.ZERO
#
	#while hand.global_position.distance_to(target) > 5 and hand_attacking:
		#print(target, hand.global_position)
		#var dir = (target - hand.global_position).normalized()
		#hand.linear_velocity = dir * speed
		#await get_tree().physics_frame
		#
	#hand.linear_velocity = Vector2.ZERO
	#await get_tree().physics_frame
#
	#while hand.global_position.distance_to(origin) > 5:
		#var dir = (origin - hand.global_position).normalized()
		#hand.linear_velocity = dir * speed
		#await get_tree().physics_frame
#
	#hand.linear_velocity = Vector2(1,1)
	#hand.global_position = origin
#
#func _on_player_get_hitted():
	#hand_attacking = false
	#pass
