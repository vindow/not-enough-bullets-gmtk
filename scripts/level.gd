extends Node2D

onready var camera = get_node("camera")
var asteroid = preload("res://scenes/units/enemies/enemy_asteroid.tscn")
var grunt = preload("res://scenes/units/enemies/enemy_grunt.tscn")
var circle = preload("res://scenes/units/enemies/enemy_circle.tscn")
var wavy = preload("res://scenes/units/enemies/enemy_wavy.tscn")
var sneaky = preload("res://scenes/units/enemies/enemy_sneaky.tscn")
var camera_speed = -200;

var score_text = preload("res://scenes/UI/score_text.tscn")

var score = 0
signal score_change(score_amount)

func _ready():
	randomize()

func _physics_process(delta):
	camera.position.y += camera_speed * delta
	if camera.position.y <= get_node("ParallaxBackground").scroll_limit_begin.y:
		get_node("/root/global").final_score = score
		get_tree().change_scene("res://scenes/UI/win_screen.tscn")
	
func add_score(amount, pos):
	score += amount
	var score_instance = score_text.instance()
	score_instance.position = pos
	score_instance.set_score(amount)
	add_child(score_instance)
	emit_signal("score_change", score)
	
func game_over():
	get_node("/root/global").final_score = score
	get_tree().change_scene("res://scenes/UI/game_over.tscn")

func _on_asteroid_timer_timeout():
	var ainstance = asteroid.instance()
	ainstance.position.y = camera.position.y - get_viewport_rect().size.y / 2 - 16
	ainstance.position.x = rand_range(16, 1008)
	add_child(ainstance)


func _on_grunt_enemy_timer_timeout():
	var ginstance = grunt.instance()
	ginstance.position.y = camera.position.y - get_viewport_rect().size.y / 2 - 16
	ginstance.position.x = rand_range(16, 1008)
	ginstance.rotation = rand_range(PI / 4, 3 * PI / 4)
	add_child(ginstance)


func _on_circle_enemy_timer_timeout():
	var cinstance = circle.instance()
	cinstance.position.y = camera.position.y - get_viewport_rect().size.y / 2 - 16
	cinstance.position.x = rand_range(16, 1008)
	cinstance.rotation = rand_range(0, PI * 2)
	if randi() % 2 == 0:
		cinstance.turn_speed *= -1
	add_child(cinstance)


func _on_wavy_enemy_timer_timeout():
	var winstance = wavy.instance()
	winstance.position.y = camera.position.y - get_viewport_rect().size.y / 2 - 16
	winstance.position.x = rand_range(16, 1008)
	winstance.rotation = rand_range(PI / 3, 2 * PI / 3)
	winstance.max_turn_angle = 60.0
	add_child(winstance)


func _on_sneaky_enemy_timer_timeout():
	var sintance = sneaky.instance()
	sintance.position.y = camera.position.y - get_viewport_rect().size.y / 2 - 16
	sintance.position.x = rand_range(16, 1008)
	sintance.rotation = rand_range(PI / 4, 3 * PI / 4)
	sintance.velocity = 700
	add_child(sintance)
