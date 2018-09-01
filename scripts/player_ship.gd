extends Area2D

var velocity = 350
var throttled_velocity = 250

# Variables to track how much barrier is left
var max_barrier_time = 3.0
var barrier_time = 3.0
# Variables to track when to start recharging when the barrier is not active
var barrier_recharge_cd = 1.0
var barrier_recharge_timer = 1.0
# Rate at which the barrier recharges (multiplied with delta)
var barrier_recharge_rate = 3.0
signal barrier_change(charge)

var camera = null
var h_offset = 0
var w_offset = 0

func _ready():
	camera = get_parent().get_node("camera")
	h_offset = get_node("Sprite").texture.get_height() / 2
	w_offset = get_node("Sprite").texture.get_width() / 2

func _physics_process(delta):
	process_movement(delta)
	# Check if the player is using the barrier and if they can
	if Input.is_action_pressed("use_barrier") and barrier_time > 0:
		get_node("player_barrier").enable()
		change_barrier(-delta)
		barrier_recharge_timer = 0.0
	else:
		get_node("player_barrier").disable()
		recharge_barrier(delta)

# Gets player input and moves the player based on that input
func process_movement(delta):
	# create a temporary variable to get the desired movement direction
	var move_direction = Vector2(0,0)
	
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
		barrier_time = max_barrier_time
	elif barrier_time < 0.0:
		barrier_time = 0.0
	emit_signal("barrier_change", barrier_time)


func die():
	print("player hit by enemy!")
	# TODO: Destroy the player, decrement a life, game over if no lives left
	pass

# On collision with enemy
func _on_player_ship_area_entered(area):
	die()
