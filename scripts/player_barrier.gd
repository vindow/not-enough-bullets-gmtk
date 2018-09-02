extends Area2D

var projectile = preload("res://scenes/units/projectile.tscn")
var pvelocity = 700;

signal hit_enemy

func _ready():
	pass

func disable():
	get_node("CollisionShape2D").disabled = true
	get_node("Sprite").visible = false

func enable():
	get_node("CollisionShape2D").disabled = false
	get_node("Sprite").visible = true


func _on_player_barrier_area_entered(area):
	# TODO: Destroy the enemy area and spawn a ship projectile
	if area.has_method("take_hit"):
		pass
	elif area.has_method("shield_kill"):
		#print("Hit enemy position" + String(area.position))
		area.shield_kill()
		spawn_projectile(area)
		emit_signal("hit_enemy")

func spawn_projectile(enemy):
	randomize()
	if randi() % 2 == 0:
		get_node("shield_hit_1").play()
	else:
		get_node("shield_hit_2").play()
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