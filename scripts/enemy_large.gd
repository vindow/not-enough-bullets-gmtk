extends "res://scripts/enemy.gd"

export var health = 1

func _ready():
	get_node("AnimationPlayer").play("twin_thrusters")
	score_amount = 500

func move(delta):
	# Move in a straight line in the direction spawned as
	move_amount = direction * velocity * delta
	.move(delta)

# Decrement HP, kill if hp is gone
func take_hit():
	health -= 1
	if health <= 0:
		kill()

# Override impelentation so that enemy can take multiple hits
func _on_enemy_body_entered(body):
	if body.has_method("kill"):
		body.kill()
	take_hit()

func kill():
	#TODO: Start the death timer, play a death animation(explosion), play a death sound
	get_node("AnimationPlayer").play("explode_mega")
	call_deferred("set_monitoring", false)
	call_deferred("set_monitorable", false)
	#monitorable = false
	randomize()
	if randi() % 2 == 0:
		get_node("explode_sound_1").play()
	else:
		get_node("explode_sound_2").play()
	get_parent().add_score(score_amount, position)
	despawn()