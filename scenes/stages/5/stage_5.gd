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
var is_complete: bool = false

func _ready() -> void:
	var path = get_tree().current_scene.scene_file_path
	var file_name = path.get_file().get_basename()
	var parts = file_name.split("_")
	var stage_number = int(parts[1])
	
	GameState.current_stage = stage_number
	hint.set_stage(stage_number)
	if GameState.is_start_stage:
		transtion.show()
		transtion.play()
		await transtion.finished
		transtion.hide()
		GameState.is_intro = true
		hint.show()
		await get_tree().create_timer(4).timeout
		hint.hide()
		GameState.is_intro = false
		GameState.is_start_stage = false

	outline_mat = ShaderMaterial.new()
	outline_mat.shader = outline_shader

func _input(event: InputEvent) -> void:
	if not GameState.is_intro:
		if event.is_action_pressed("move_hand") and not is_patpat and can_patpat:
			pat_cat()
		if (event.is_action_pressed("move_hand") or event.is_action_pressed("submit")) and is_complete and $Flag.button_texture.visible:
			$Flag.change_e_texture(true)
			await get_tree().create_timer(0.5)
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
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
	is_patpat = false
	tween.tween_property($Cat, "modulate:a", 0.0, 1)
	await tween.finished
	$Cat.hide()
	is_complete = true


func _on_area_area_entered(area: Area2D) -> void:
	if area.name == "HandArea":
		$Flag.is_completed = true
		$Flag.button_texture.show()

func _on_area_area_exited(area: Area2D) -> void:
	if area.name == "HandArea":
		$Flag.button_texture.hide()
