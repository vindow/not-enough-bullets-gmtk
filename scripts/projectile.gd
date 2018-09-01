extends RigidBody2D

var torque = 0
var spin_direction = 1

func _ready():
	# Generate a random spin speed and direction
	randomize()
	torque = rand_range(10, 20)
	if randi() % 2 == 0:
		spin_direction = 1;
	else:
		spin_direction = -1;

func _integrate_forces(state):
	state.angular_velocity = spin_direction * torque

func kill():
	#TODO: Start a death timer, play an explosion sound and animation
	queue_free()