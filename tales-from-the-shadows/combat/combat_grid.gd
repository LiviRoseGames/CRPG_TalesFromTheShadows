class_name CombatGrid
extends TileMapLayer

@onready var highlight := $Highlight

var hovered_cell := Vector2i(-1, -1)

var occupied_cells: Dictionary = {}

const CELL_SIZE_FEET: int = 5

signal cell_clicked(cell: Vector2i)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell := world_to_grid(event.position)

			if is_cell_valid(cell):
				cell_clicked.emit(cell)

func grid_to_world(grid_position: Vector2i) -> Vector2:
	return to_global(map_to_local(grid_position))

func world_to_grid(world_position: Vector2) -> Vector2i:
	return local_to_map(to_local(world_position))

func is_in_bounds(grid_position: Vector2i) -> bool:
	var used_rect := get_used_rect()
	return used_rect.has_point(grid_position)

func place_combatant(combatant: Combatant, position: Vector2i) -> void:
	if not is_in_bounds(position):
		push_warning("Cannot place combatant outside the grid: " + str(position))
		return

	if occupied_cells.has(position):
		push_warning("Grid cell is already occupied: " + str(position))
		return

	combatant.grid_position = position
	combatant.global_position = grid_to_world(position)

	occupied_cells[position] = combatant

func is_occupied(position: Vector2i) -> bool:
	return occupied_cells.has(position)

func get_combatant_at(position: Vector2i) -> Combatant:
	return occupied_cells.get(position)

func move_combatant(combatant: Combatant, new_position: Vector2i) -> bool:
	if not is_in_bounds(new_position):
		return false

	if occupied_cells.has(new_position):
		return false

	var old_position := combatant.grid_position

	occupied_cells.erase(old_position)

	combatant.grid_position = new_position
	combatant.global_position = grid_to_world(new_position)

	occupied_cells[new_position] = combatant

	return true

func _process(_delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var cell := world_to_grid(mouse_position)

	if cell != hovered_cell:
		hovered_cell = cell
		update_highlight()


func update_highlight() -> void:
	if hovered_cell.x < 0 or hovered_cell.y < 0:
		highlight.visible = false
		return

	if not is_cell_valid(hovered_cell):
		highlight.visible = false
		return

	highlight.visible = true
	highlight.global_position = grid_to_world(hovered_cell)

func is_cell_valid(cell: Vector2i) -> bool:
	return (
		cell.x >= 0
		and cell.x < 10
		and cell.y >= 0
		and cell.y < 15
	)

func get_reachable_cells(
	start: Vector2i,
	movement: int
) -> Array[Vector2i]:

	var reachable: Array[Vector2i] = []

	var movement_cells: int = movement / CELL_SIZE_FEET

	for x in range(10):
		for y in range(15):
			var cell := Vector2i(x, y)

			var distance: int = (
				abs(cell.x - start.x)
				+ abs(cell.y - start.y)
			)

			if distance <= movement_cells:
				reachable.append(cell)

	return reachable

func show_movement_range(
	start: Vector2i,
	movement: int
) -> void:

	clear_movement_range()

	var reachable: Array[Vector2i] = get_reachable_cells(
		start,
		movement
	)

	for cell in reachable:
		var highlight := $Highlight.duplicate()

		highlight.visible = true
		highlight.global_position = grid_to_world(cell)

		$MovementHighlights.add_child(highlight)

func clear_movement_range() -> void:
	for child in $MovementHighlights.get_children():
		child.queue_free()
