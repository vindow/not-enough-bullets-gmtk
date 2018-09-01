extends "res://scripts/enemy.gd"

export var health = 2
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

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
