extends "res://scripts/enemy.gd"

func _ready():
	pass
	
func move(delta):
	# Move in a straight line in the direction spawned as
	move_amount = direction * velocity * delta
	.move(delta)