extends "res://scripts/enemy.gd"

export var turn_speed = 1.0

func _ready():
	pass

func move(delta):
	rotation += turn_speed * delta
	direction = Vector2(cos(rotation), sin(rotation)).normalized()
	move_amount = direction * velocity * delta
	.move(delta)