extends Area2D

# Variable for enemy velocity relative to camera
export var velocity = 400.0
var direction = Vector2(0, 0)

var move_amount = Vector2(0, 0)

func _ready():
	direction = Vector2(cos(rotation), sin(rotation)).normalized()
	
func _physics_process(delta):
	# Move the enemy forward with the camera so all speeds can be set relative to the camera
	move(delta)

# Override this method to implement moving behavior
func move(delta):
	# Move the enemy 200 upward to ensure movement is relative to the camera
	move_amount.y -= 200 * delta
	position += move_amount


func kill():
	#TODO: Start the death timer, play a death animation(explosion), play a death sound
	queue_free()


func _on_enemy_body_entered(body):
	if body.has_method("kill"):
		body.kill()
	kill()
