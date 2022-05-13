tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var size := Vector2.ONE * 50;

# Called when the node enters the scene tree for the first time.
func _ready():
	var INVALID_CELL = $wall_tiles.INVALID_CELL
	
	for y in range(- size.y / 2, size.y):
		for x in range(- size.x / 2, size.x):
			if $wall_tiles.get_cell(x, y) == INVALID_CELL:
				if $wall_tiles.get_cell(x - 1, y) == 0:
					
					if $wall_tiles.get_cell(x, y - 1) == 0:
						$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(2, 0));
					elif $wall_tiles.get_cell(x - 1, y - 1) == INVALID_CELL:
						$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(0, 1));
					else:
						$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(0, 0));
						
				elif $wall_tiles.get_cell(x, y - 1) == 0:
					if $wall_tiles.get_cell(x - 1, y - 1) == INVALID_CELL:
						$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(1, 1));
					else:
						$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(1, 0));
					
				elif $wall_tiles.get_cell(x - 1, y - 1) == 0:
					$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(2, 1));
					
				else:
					$floor_tile.set_cell(x, y, 2, false, false, false, Vector2(0, 2));
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
