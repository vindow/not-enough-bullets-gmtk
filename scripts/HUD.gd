extends Container

onready var energy_bar = get_node("Container/energy_bar")

func _ready():
	var player_max_barrier = $"../../player_ship".max_barrier_time
	energy_bar.max_value = player_max_barrier

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_player_ship_barrier_change(charge):
	energy_bar.value = charge
