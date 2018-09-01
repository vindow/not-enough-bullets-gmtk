extends Area2D

export var velocity = 600
export var direction = Vector2(0, 0)

func _ready():
	pass

func _physics_process(delta):
	position += direction * velocity * delta