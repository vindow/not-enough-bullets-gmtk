extends "res://scripts/enemy.gd"

export var turn_speed = 1.0

func _ready():
	pass

func move(delta):
	# Slowly rotate
	rotation += turn_speed * delta
	# Get the vectorized rotation
	direction = Vector2(cos(rotation), sin(rotation)).normalized()
	# Move in the forward direction
	move_amount = direction * velocity * delta
	.move(delta)