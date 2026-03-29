extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 200.0
var is_last_dir_right: bool = true

func _ready() -> void:
	play_if_not("idle")

func _physics_process(delta):
	var direction := Vector2.ZERO

	if GameState.is_intro:
		return

	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
		is_last_dir_right = false
	if Input.is_action_pressed("right"):
		direction.x += 1
		is_last_dir_right = true

	GameState.is_player_move = direction != Vector2.ZERO

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
	if direction == Vector2.ZERO:
		play_if_not("idle" if is_last_dir_right else "idle_left")
		return

	play_if_not("run_right" if is_last_dir_right else "run_left")

func play_if_not(name: String):
	if animated_sprite.animation != name:
		animated_sprite.play(name)

func play_animation(frame: String):
	play_if_not(frame)
