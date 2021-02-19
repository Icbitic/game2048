extends Node2D

const slip_edge = 100

var movement = Vector2(0, 0)
var score = 0
signal slip

var is_slipped = false
func _on_map_merged(value):
	score += value

func _input(event):
	#Desktop
	if event.is_action_pressed("ui_up"):
		emit_signal("slip", Vector2(0, -1))
		
	if event.is_action_pressed("ui_down"):
		emit_signal("slip", Vector2(0, 1))
		
	if event.is_action_pressed("ui_left"):
		emit_signal("slip", Vector2(-1, 0))
		
	if event.is_action_pressed("ui_right"):
		emit_signal("slip", Vector2(1, 0))
		
	#Android (iOS is NOT my business)
	if !Input.is_mouse_button_pressed(1):
		is_slipped = false
		movement = Vector2(0, 0)
	if event is InputEventScreenDrag and !is_slipped:
		movement += event.relative
	
	if movement.y <= -slip_edge and !is_slipped:
		emit_signal("slip", Vector2(0, -1))
		movement = Vector2(0, 0)
		is_slipped = true
		
	if movement.y >= slip_edge and !is_slipped:
		emit_signal("slip", Vector2(0, 1))
		movement = Vector2(0, 0)
		is_slipped = true
		
	if movement.x <= -slip_edge and !is_slipped:
		emit_signal("slip", Vector2(-1, 0))
		movement = Vector2(0, 0)
		is_slipped = true
		
	if movement.x >= slip_edge and !is_slipped:
		emit_signal("slip", Vector2(1, 0))
		movement = Vector2(0, 0)
		is_slipped = true
