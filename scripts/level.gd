extends Node2D

onready var camera = get_node("camera")
var camera_speed = -200;

func _ready():
	pass

func _physics_process(delta):
	camera.position.y += camera_speed * delta