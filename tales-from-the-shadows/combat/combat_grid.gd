extends TileMapLayer
class_name CombatGrid

@export var grid_size := Vector2i(10, 8)
@export var cell_size := 64

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var position := Vector2(x * cell_size, y * cell_size)
			draw_rect(
				Rect2(position, Vector2(cell_size, cell_size)),
				Color.TRANSPARENT,
				false,
				1.0
			)
