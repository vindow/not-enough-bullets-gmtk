extends Area2D

export var velocity = 400

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _physics_process(delta):
	# Move the enemy forward with the camera so all speeds can be set relative to the camera
	position.y -= 200 * delta

func kill():
	#TODO: Start the death timer, play a death animation(explosion), play a death sound
	queue_free()


func _on_enemy_body_entered(body):
	if body.has_method("kill"):
		body.kill()
	kill()
