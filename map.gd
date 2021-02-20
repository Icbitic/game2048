extends TileMap

func _process(delta):
	for i in range(0, 4):
		for j in range(0, 4):
			set_cell(i, j, get_parent().get_map(i, j))
