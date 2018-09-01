extends Area2D

export var velocity = 400

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func kill():
	#TODO: Start the death timer, play a death animation(explosion), play a death sound
	queue_free()


func _on_enemy_body_entered(body):
	if body.has_method("kill"):
		body.kill()
	kill()
