extends Node2D

var score = 0
signal slip

func _on_map_merged(value):
	score += value

func _input(event):
	if event.is_action_pressed("ui_up"):
		emit_signal("slip", Vector2(0, -1))
		
	if event.is_action_pressed("ui_down"):
		emit_signal("slip", Vector2(0, 1))
		
	if event.is_action_pressed("ui_left"):
		emit_signal("slip", Vector2(-1, 0))
		
	if event.is_action_pressed("ui_right"):
		emit_signal("slip", Vector2(1, 0))
		
