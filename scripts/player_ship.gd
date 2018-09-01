extends Area2D

var velocity = 350
var throttled_velocity = 250

# Variables to track how much barrier is left
var max_barrier_time = 4.0
var barrier_time = 4.0
# Variables to track when to start recharging when the barrier is not active
var barrier_recharge_cd = 1.0
var barrier_recharge_timer = 1.0
# Rate at which the barrier recharges (multiplied with delta)
var barrier_recharge_rate = 0.75

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
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
	
	# Check if the player is using the barrier and if they can
	if Input.is_action_pressed("use_barrier") and barrier_time > 0:
		get_node("player_barrier").enable()
		barrier_time -= delta
		barrier_recharge_timer = 0.0
	else:
		get_node("player_barrier").disable()
		# Check if can recharge
		if barrier_recharge_timer >= barrier_recharge_cd:
			barrier_time += delta * barrier_recharge_rate
			# Clamp the barrier_time if it exceeds the max
			if barrier_time > max_barrier_time:
				barrier_time = max_barrier_time
		else:
			#tick up the barrier recharge timer instead
			barrier_recharge_timer += delta

func die():
	print("player hit by enemy!")
	# TODO: Destroy the player, decrement a life, game over if no lives left
	pass

# On collision with enemy
func _on_player_ship_area_entered(area):
	die()
