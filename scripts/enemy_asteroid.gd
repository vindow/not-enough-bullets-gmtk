extends "res://scripts/enemy.gd"

var spin_velocity = 0.0;

func _ready():
	randomize()
	spin_velocity = rand_range(0.5, 1)
	#velocity = rand_range(450, 650)

func _physics_process(delta):
	position.y += velocity * delta
	rotation += spin_velocity * delta