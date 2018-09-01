extends Area2D

var projectile = preload("res://scenes/units/projectile.tscn")
var pvelocity = 700;
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
	# TODO: Destroy the enemy area and spawn a ship projectile
	if area.has_method("kill"):
		area.kill()
		spawn_projectile(area)
	pass # replace with function body

func spawn_projectile(enemy):
	# Get the texture to set the projectile to
	var enemy_tex = enemy.get_node("Sprite").texture
	# Instantiate the projectile and set it's position, rotation, and texture
	var pinstance = projectile.instance()
	pinstance.position = enemy.position
	pinstance.rotation = enemy.rotation
	pinstance.get_node("Sprite").texture = enemy_tex
	
	# Apply an impulse to the projectile based on barrier hit location
	pinstance.apply_impulse(Vector2(0, 0), pvelocity * calculate_launch_angle(enemy))
	
	get_parent().get_parent().add_child(pinstance)

func calculate_launch_angle(enemy):
	var angle = enemy.rotation
	# Get the normal of the collision vector
	var normal = (enemy.position - get_parent().position).normalized().tangent()
	# Reflect the enemy's current angle off the normal
	return Vector2(cos(angle), sin(angle)).reflect(normal).normalized()