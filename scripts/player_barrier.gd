extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func disable():
	get_node("CollisionShape2D").disabled = true
	get_node("Sprite").visible = false

func enable():
	get_node("CollisionShape2D").disabled = false
	get_node("Sprite").visible = true
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_player_barrier_area_entered(area):
	# TODO: Destroy the enemy area and spawn an ship projectile
	if area.has_method("kill"):
		area.kill()
	pass # replace with function body
