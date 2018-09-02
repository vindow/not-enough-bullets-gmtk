extends "res://scripts/enemy.gd"

func _ready():
	get_node("AnimationPlayer").play("thrusters")
	score_amount = 200
	
func move(delta):
	# Move in a straight line in the direction spawned as
	move_amount = direction * velocity * delta
	.move(delta)