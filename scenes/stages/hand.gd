extends RigidBody2D

signal hit_target(body)

@onready var hit_area = $HitBox

func _ready():
	hit_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	emit_signal("hit_target", body)
