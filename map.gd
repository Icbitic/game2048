extends TileMap

signal merged
func place():
	var placeable = []
	for i in range(0, 4):
		for j in range(0, 4):
			if get_cell(i, j) == -1:
				placeable.append(Vector2(i, j))
	if placeable.size() != 0:
		if randi() % 10 < 3:
			set_cellv(placeable[randi() % placeable.size()], 1)
		else:
			set_cellv(placeable[randi() % placeable.size()], 0)
	
func _ready():
	place()
	
func _on_Game2048_slip(direction):
	var merged_cell = []
	for i in range(0, 4):
		for j in range(0, 4):
			for x in range(1,4):
				var checked_pos = Vector2(i, j) + direction * x
				if checked_pos.x in range(0, 4) and checked_pos.y in range(0, 4):
					if get_cellv(checked_pos) == get_cell(i, j) and get_cellv(checked_pos) != -1:
						break
						if !merged_cell.has(Vector2(i, j)):
							set_cellv(checked_pos, get_cellv(checked_pos) + 1)
							set_cell(i, j, -1)
							merged_cell.append(checked_pos)
							emit_signal("merged", pow(2, get_cellv(checked_pos) + 1))
	
	for x in range(1,4):
		for i in range(0, 4):
			for j in range(0, 4):
				var checked_pos = Vector2(i, j) + direction
				if checked_pos.x in range(0, 4) and checked_pos.y in range(0, 4):
					if get_cellv(checked_pos) == -1:
						set_cellv(checked_pos, get_cell(i, j))
						set_cell(i, j, -1)
	place()
