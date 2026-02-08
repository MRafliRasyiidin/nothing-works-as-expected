extends Control

var mouse_global_position: Vector2
@onready var hand: Node2D = $Hand
@onready var outline_shader = load("res://scenes/stages/5/outline.gdshader")
@onready var cat_sprite = $Cat/AnimatedSprite2D
@onready var cat_area = $Cat/Area2D
@onready var hand_area: Area2D = $Hand/HandArea
@onready var hint: Control = $StageIntro
@onready var transtion = $Transition

var outline_mat: ShaderMaterial

var is_patpat: bool = false
var can_patpat: bool = false

func _ready() -> void:
	if GameState.is_start_stage:
		transtion.show()
		transtion.play()
		await transtion.finished
		transtion.hide()
		GameState.is_intro = true
		hint.set_label('What do you do when you saw a cat?')
		hint.show()
		await get_tree().create_timer(3).timeout
		hint.hide()
		GameState.is_intro = false
		GameState.is_start_stage = false

	outline_mat = ShaderMaterial.new()
	outline_mat.shader = outline_shader

func _input(event: InputEvent) -> void:
	if not GameState.is_intro:
		if event.is_action_pressed("move_hand") and not is_patpat and can_patpat:
			pat_cat()
	
func _process(delta):
	if not GameState.is_intro:
		if not is_patpat:
			hand.global_position = get_global_mouse_position()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "HandArea":
		can_patpat = true
		cat_sprite.play("happy")
		cat_sprite.material = outline_mat

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "HandArea":
		can_patpat = false
		cat_sprite.play("idle")
		cat_sprite.material = null

func pat_cat():
	is_patpat = true
	var tween: Tween = create_tween()
	var origin_rotation = hand.rotation_degrees
	for i in range(5):
		tween.tween_property(hand, "rotation_degrees", -30, 0.3)
		tween.tween_property(hand, "rotation_degrees", 10, 0.3)
	tween.tween_property(hand, "rotation_degrees", origin_rotation, 0.3)
	await tween.finished
	is_patpat = false
