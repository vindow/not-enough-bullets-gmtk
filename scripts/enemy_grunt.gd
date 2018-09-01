extends "res://scripts/enemy.gd"

export var direction = Vector2(0, 0)

func _ready():
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * velocity * delta