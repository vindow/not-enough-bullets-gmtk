extends "res://scripts/enemy.gd"

func _ready():
	pass
	
func move(delta):
	move_amount = direction * velocity * delta
	.move(delta)