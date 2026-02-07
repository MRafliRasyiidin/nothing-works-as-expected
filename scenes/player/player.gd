extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 200.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			var push_dir = -collision.get_normal()
			if direction.dot(push_dir) > 0:
				collider.apply_central_impulse(push_dir * 5.0)
	
	update_animation(direction)

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		animation.play("idle")
		return
	
	if abs(direction.x) > abs(direction.y):
		animation.play("walk_right" if direction.x > 0 else "walk_left")
	else:
		animation.play("walk_down" if direction.y > 0 else "walk_up")
