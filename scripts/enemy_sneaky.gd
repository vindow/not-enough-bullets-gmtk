extends "res://scripts/enemy.gd"

# Variable to store how long before unit targets the player
export var attack_delay = 1.5
# Variable for unit turn speed (higher makes it more accurate)
export var turn_speed = 3.0
# Variable for the velocity of the unit while it turns. Too fast and it'll run off the screen
export var velocity_while_turning = 100.0

var desired_angle = 0.0
var locked_on = false

func _ready():
	get_node("AnimationPlayer").play("thrusters")
	score_amount = 400

func move(delta):
	if attack_delay > 0:
		move_amount = direction * velocity_while_turning * delta
		attack_delay -= delta
	else:
		if not locked_on:
			# Get the angle that points unit to the player
			desired_angle = (position - get_parent().get_node("player_ship").position).angle() + PI
			# Check if on target. Some leniency added due to floats almost never being equal
			if rotation > desired_angle - PI / 30 and rotation < desired_angle + PI / 30:
				locked_on = true
			#Otherwise turn towards the target
			elif rotation < desired_angle:
				rotation += turn_speed * delta
			elif rotation > desired_angle:
				rotation -= turn_speed * delta
			# Move towards the target
			direction = Vector2(cos(rotation), sin(rotation)).normalized()
			move_amount = direction * velocity_while_turning * delta
		else:
			# If on target dash towards the player
			direction = Vector2(cos(rotation), sin(rotation)).normalized()
			move_amount = direction * velocity * delta
	.move(delta)
