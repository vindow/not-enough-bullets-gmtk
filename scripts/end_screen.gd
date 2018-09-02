extends "res://scripts/main_menu.gd"

func _ready():
	get_node("VBoxContainer/score").text = "Final Score: " + String(get_node("/root/global").final_score)
