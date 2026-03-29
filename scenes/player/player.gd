extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $HorseSprite
@export var speed: float = 200.0

signal get_hitted

var is_start := true
var last_facing := 1

func _ready():
	animation.play("start")

func _physics_process(delta):
	var direction := Vector2.ZERO

	if GameState.is_intro || GameState.disable_move:
		return

	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		is_start = false

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is RigidBody2D:
			if collider.name == "Hand" and GameState.is_hand_attacking:
				emit_signal("get_hitted")
			else:
				var push_dir = -collision.get_normal()
				if direction.dot(push_dir) > 0:
					collider.apply_central_impulse(push_dir * 10.0)

	update_animation(direction)

func update_animation(direction: Vector2):
	if is_start:
		return

	if direction.x != 0:
		last_facing = sign(direction.x)

	if direction == Vector2.ZERO:
		if last_facing > 0:
			animation.play("idle_right")
		else:
			animation.play("idle_left")
		return

	if last_facing > 0:
		animation.play("walk_right")
	else:
		animation.play("walk_left")

func play_anim(animation_name: String, wait_for_complete: bool = false):
	animation.play(animation_name)
	if wait_for_complete:
		await animation.animation_finished
