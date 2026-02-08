extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 200.0
var is_last_dir_right: bool = true

func _ready() -> void:
	animated_sprite.play("idle")
	
func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if not GameState.is_intro:
		if Input.is_action_pressed("up"):
			direction.y -= 1
			GameState.is_player_move = true
		if Input.is_action_pressed("down"):
			direction.y += 1
			GameState.is_player_move = true
		if Input.is_action_pressed("left"):
			direction.x -= 1
			GameState.is_player_move = true
			is_last_dir_right = false
		if Input.is_action_pressed("right"):
			direction.x += 1
			GameState.is_player_move = true
			is_last_dir_right = true
		
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider is RigidBody2D:
				if collider.name == "Hand" && GameState.is_hand_attacking:
					emit_signal("get_hitted")
				else:
					var push_dir = -collision.get_normal()
					if direction.dot(push_dir) > 0:
						collider.apply_central_impulse(push_dir * 10.0)
		
		update_animation(direction)
		
func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		GameState.is_player_move = false
		animated_sprite.play("idle" if is_last_dir_right else "idle_left")
		return
		
	if abs(direction.x) > abs(direction.y):
		animated_sprite.play("run_right" if direction.x > 0 else "run_left")
	else:
		animated_sprite.play("run_down" if direction.y > 0 else "run_up")
		
func play_animation(frame: String):
	animated_sprite.play(frame)
	
