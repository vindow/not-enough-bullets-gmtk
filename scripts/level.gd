extends Node2D

onready var camera = get_node("camera")
var asteroid = preload("res://scenes/units/enemies/enemy_asteroid.tscn")
var camera_speed = -200;

func _ready():
	randomize()
	pass

func _physics_process(delta):
	camera.position.y += camera_speed * delta

func _on_asteroid_timer_timeout():
	var ainstance = asteroid.instance()
	ainstance.position.y = camera.position.y - get_viewport_rect().size.y / 2 - 16
	ainstance.position.x = rand_range(16, 1008)
	add_child(ainstance)
