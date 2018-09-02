extends Area2D

# Variable for enemy velocity relative to camera
export var velocity = 400.0
var score_amount = 100

var direction = Vector2(0, 0)
var move_amount = Vector2(0, 0)

var camera = null
var camera_offset = 0.0
var has_spawned = false
var can_move = false

func _ready():
	direction = Vector2(cos(rotation), sin(rotation)).normalized()
	camera = get_parent().get_node("camera")
	camera_offset = get_viewport_rect().size.y / 2 - get_node("Sprite").texture.get_height() / 2


func _physics_process(delta):
	# Don't move enemies until the are near the camera
	if can_move:
		move(delta)
	elif camera.position.y - camera_offset < position.y: 
		get_node("SpawnTimer").start()
		can_move = true


# Override this method to implement moving behavior
func move(delta):
	# Move the enemy 200 upward to ensure enemy movement is relative to the camera
	move_amount.y -= 200 * delta
	position += move_amount


func kill():
	#TODO: Start the death timer, play a death animation(explosion), play a death sound
	get_node("AnimationPlayer").play("explode")
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


func shield_kill():
	#print("Enemy dying position" + String(position))
	get_node("AnimationPlayer").play("explode_small")
	call_deferred("set_monitoring", false)
	call_deferred("set_monitorable", false)
	get_parent().add_score(100, position)
	despawn()


func despawn():
	get_node("kill_timer").start()


func _on_enemy_body_entered(body):
	if body.has_method("kill"):
		body.kill()
	kill()


func _on_SpawnNotifier_screen_exited():
	if has_spawned:
		despawn()


func _on_SpawnTimer_timeout():
	has_spawned = true


func _on_kill_timer_timeout():
	queue_free()
