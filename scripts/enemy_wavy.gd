extends "res://scripts/enemy.gd"

# Variable to set turn speed, affecting the frequency of the wave pattern
export var turn_speed = 2.0
#Variable to set maximum angle before the unit should turn around
export var max_turn_angle = 60.0

var initial_rotation = 0.0

func _ready():
	initial_rotation = rotation
	get_node("AnimationPlayer").play("thrusters")
	score_amount = 300

func move(delta):
	# Slowly rotate
	rotation += turn_speed * delta
	if abs(rotation - initial_rotation) > deg2rad(max_turn_angle):
		turn_speed *= -1
	# Get the vectorized rotation
	direction = Vector2(cos(rotation), sin(rotation)).normalized()
	# Move in the forward direction
	move_amount = direction * velocity * delta
	.move(delta)
