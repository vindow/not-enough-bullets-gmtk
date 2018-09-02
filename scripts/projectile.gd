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
	get_node("AnimationPlayer").play("explode")
	get_node("death_timer").start()
	get_node("collision_timer").start()
	
func despawn():
	queue_free()

func _on_despawn_notifier_screen_exited():
	despawn()


func _on_death_timer_timeout():
	despawn()


func _on_collision_timer_timeout():
	get_node("CollisionShape2D").queue_free()
