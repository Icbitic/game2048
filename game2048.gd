extends Node2D

const slip_edge = 100

var movement = Vector2(0, 0)
var score = 0
signal slip
signal merged

var is_slipped = false

var map = [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]]

func get_map(x, y):
	return map[x][y]
func get_mapv(pos):
	return map[pos.x][pos.y]
func set_map(x, y, v):
	map[x][y] = v
func set_mapv(pos, v):
	map[pos.x][pos.y] = v
	
	
func place():
	var placeable = []
	for i in range(0, 4):
		for j in range(0, 4):
			if get_map(i, j) == -1:
				placeable.append(Vector2(i, j))
	if placeable.size() != 0:
		if randi() % 10 < 3:
			set_mapv(placeable[randi() % placeable.size()], 1)
		else:
			set_mapv(placeable[randi() % placeable.size()], 0)
	
	
func _ready():
	place()
	
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
		
func _on_Game2048_slip(direction):
	var merged_cell = []
	for i in range(0, 4):
		for j in range(0, 4):
			for x in range(1,4):
				var checked_pos = Vector2(i, j) + direction * x
				if checked_pos.x in range(0, 4) and checked_pos.y in range(0, 4):
					if get_mapv(checked_pos) == get_map(i, j) and get_mapv(checked_pos) != -1 and !merged_cell.has(Vector2(i, j)):
						set_mapv(checked_pos, get_mapv(checked_pos) + 1)
						set_map(i, j, -1)
						merged_cell.append(checked_pos)
						emit_signal("merged", pow(2, get_mapv(checked_pos) + 1))
						break
					if get_mapv(checked_pos) != get_map(i, j) and get_mapv(checked_pos) != -1:
						break
	
	for x in range(1,4):
		for i in range(0, 4):
			for j in range(0, 4):
				var checked_pos = Vector2(i, j) + direction
				if checked_pos.x in range(0, 4) and checked_pos.y in range(0, 4):
					if get_mapv(checked_pos) == -1:
						set_mapv(checked_pos, get_map(i, j))
						set_map(i, j, -1)
	place()

func _on_Game2048_merged(value):
	score += value
