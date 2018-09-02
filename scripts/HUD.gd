extends Container

onready var energy_bar = get_node("energy/energy_bar")
onready var life_counter = get_node("lives/life_counter")
onready var score = get_node("score")

func _ready():
	var player_max_barrier = $"../../player_ship".max_barrier_time
	energy_bar.max_value = player_max_barrier
	energy_bar.value = $"../../player_ship".barrier_time
	life_counter.text = "x" + String($"../../player_ship".lives)


func _on_player_ship_barrier_change(charge):
	energy_bar.value = charge


func _on_player_ship_life_change(num_lives):
	life_counter.text = "x" + String(num_lives)


func _on_test_level_score_change(score_amount):
	score.text = String(score_amount)
