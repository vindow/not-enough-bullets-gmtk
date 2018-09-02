extends Node2D


func _ready():
	get_node("AnimationPlayer").play("display_score")

func _physics_process(delta):
	position.y -= 200 * delta

func set_score(amount):
	get_node("score").text = String(amount)

func _on_despawn_timer_timeout():
	queue_free()
