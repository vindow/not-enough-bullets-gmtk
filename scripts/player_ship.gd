extends Area2D

var velocity = 350
var throttled_velocity = 250

var lives = 4
signal life_change(num_lives)

var can_move = true

# Variables to track how much barrier is left
var max_barrier_time = 5.0
var barrier_time = 5.0
# Variables to track when to start recharging when the barrier is not active
var barrier_recharge_cd = 1.0
var barrier_recharge_timer = 1.0
# Rate at which the barrier recharges (multiplied with delta)
var barrier_recharge_rate = 5.0
signal barrier_change(charge)

onready var barrier_active_sound = get_node("activate_barrier")
var can_play_barrier_on_sound = true

onready var barrier_off_sound = get_node("out_of_barrier")
var can_play_barrier_off_sound = false

var camera = null
var h_offset = 0
var w_offset = 0


func _ready():
	camera = get_parent().get_node("camera")
	h_offset = get_node("Sprite").texture.get_height() / 2
	w_offset = get_node("Sprite").texture.get_width() / 2
	get_node("AnimationPlayer").play("thrusters")


func _physics_process(delta):
	process_movement(delta)
	# Check if the player is using the barrier and if they can
	if Input.is_action_pressed("use_barrier") and can_move:
		if barrier_time <= 0:
			get_node("player_barrier").disable()
			if not get_node("no_charge").playing:
				get_node("no_charge").play()
			recharge_barrier(delta)
		else:
			if can_play_barrier_on_sound:
				barrier_active_sound.play()
				barrier_off_sound.stop()
				can_play_barrier_on_sound = false
				can_play_barrier_off_sound = true
			get_node("player_barrier").enable()
			change_barrier(-delta)
			barrier_recharge_timer = 0.0
	else:
		can_play_barrier_on_sound = true
		barrier_active_sound.stop()
		if can_play_barrier_off_sound:
			can_play_barrier_off_sound = false
			barrier_off_sound.play()
		get_node("player_barrier").disable()
		recharge_barrier(delta)


# Gets player input and moves the player based on that input
func process_movement(delta):
	# create a temporary variable to get the desired movement direction
	var move_direction = Vector2(0,0)
	if can_move:
		# Check y movement
		if Input.is_action_pressed("move_up"):
			move_direction.y = -1
		elif Input.is_action_pressed("move_down"):
			move_direction.y = 1
		
		# Check x movement
		if Input.is_action_pressed("move_left"):
			move_direction.x = -1
		elif Input.is_action_pressed("move_right"):
			move_direction.x = 1
	
		# Reduce the velocity if moving diagonally so that moving diagonally doesn't move faster overall
		if move_direction.y != 0 and move_direction.x != 0:
			move_direction *= sqrt(2) / 2
	
	# Move the ship, using throttled speed if the throttle button is pressed
	if Input.is_action_pressed("throttle_move"):
		position += move_direction * throttled_velocity * delta
	else:
		position += move_direction * velocity * delta
	
	# Move the player forward with the camera regardless of input
	position.y -= 200 * delta
	
	# Check if the player is offscreen, move them back if they are
	var camera_pos = camera.position
	var camera_size = get_viewport_rect().size
	
	if position.y + h_offset > camera_pos.y + camera_size.y:
		position.y = camera_pos.y + camera_size.y - h_offset
	elif position.y - h_offset < camera_pos.y:
		position.y = camera_pos.y + h_offset
		
	if position.x + w_offset > camera_pos.x + camera_size.x:
		position.x = camera_pos.x + camera_size.x - w_offset
	elif position.x - w_offset < camera_pos.x:
		position.x = camera_pos.x + w_offset

# Recharges the barrier if the recharge timer condition is met
func recharge_barrier(delta):
	# Check if can recharge
	if barrier_recharge_timer >= barrier_recharge_cd and barrier_time < max_barrier_time:
		change_barrier(delta * barrier_recharge_rate)
	else:
		# tick up the barrier recharge timer instead
		barrier_recharge_timer += delta
		

func change_barrier(amount):
	barrier_time += amount
	# Clamp the barrier charge to be between 0 and max
	if barrier_time > max_barrier_time:
		get_node("fully_charged").play()
		barrier_time = max_barrier_time
	elif barrier_time < 0.0:
		barrier_time = 0.0
	emit_signal("barrier_change", barrier_time)


func die():
	lives -= 1
	emit_signal("life_change", lives)
	get_node("death_timer").start()
	get_node("AnimationPlayer").play("explode")
	get_node("explode").play()
	call_deferred("set_monitoring", false)
	call_deferred("set_monitorable", false)
	can_move = false
	pass

# On collision with enemy
func _on_player_ship_area_entered(area):
	die()


func _on_player_barrier_hit_enemy():
	var hit_cost = max_barrier_time / -20.0
	change_barrier(hit_cost)


func _on_death_timer_timeout():
	get_node("respawn_timer").start()


func _on_respawn_timer_timeout():
	if lives == 0:
		get_parent().game_over()
	var spawn_location = get_viewport_rect().size
	spawn_location.x /= 2
	spawn_location.y -= 50
	position = camera.position + spawn_location
	can_move = true
	get_node("AnimationPlayer").play("invulnerable")
	get_node("invul_timer").start()


func _on_invul_timer_timeout():
	call_deferred("set_monitoring", true)
	call_deferred("set_monitorable", true)
