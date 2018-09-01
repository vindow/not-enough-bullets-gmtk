extends "res://scripts/enemy.gd"

var spin_velocity = 0.0;

func _ready():
	randomize()
	spin_velocity = rand_range(0.5, 1)
	velocity = rand_range(350, 600)

func move(delta):
	move_amount = Vector2(0, velocity * delta)
	rotation += spin_velocity * delta
	.move(delta)