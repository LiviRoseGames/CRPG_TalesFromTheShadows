extends Node2D

@onready var player: Combatant = $Player
@onready var enemy: Combatant = $Enemy
@onready var combat_grid: CombatGrid = $CombatGrid

@export var test_spell: SpellData

#30 feet * 10 pixels = 300 pixels
const PIXELS_PER_FOOT := 10.0

var turn_order: Array[Combatant] = []
var current_turn: int = 0

var targeting_spell: SpellData = null
var targeting: bool = false

func _ready() -> void:
	print("Combat started!")
	combat_grid.cell_clicked.connect(_on_grid_cell_clicked)

	setup_combatants()

	combat_grid.show_movement_range(
		player.grid_position,
		player.movement_speed
	)

	roll_initiative()
	start_turn()

func _input(event: InputEvent) -> void:
	if not targeting:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var target := get_combatant_at_position(event.position)

			if target != null:
				select_target(target)

func _on_grid_cell_clicked(cell: Vector2i) -> void:
	if not player.can_move_to(cell, combat_grid):
		print("Cell is not reachable: ", cell)
		return

	var moved := player.move_to_grid(cell, combat_grid)

	if not moved:
		return

	print(
		player.name,
		" moved to ",
		player.grid_position,
		". Movement remaining: ",
		player.movement_remaining
	)

	combat_grid.show_movement_range(
		player.grid_position,
		player.movement_remaining
	)

func setup_combatants() -> void:
	combat_grid.place_combatant(
		player,
		Vector2i(2, 4)
	)

	combat_grid.place_combatant(
		enemy,
		Vector2i(9, 4)
	)

func get_combatant_at_position(mouse_position: Vector2) -> Combatant:
	var combatants: Array[Combatant] = [
		player,
		enemy
	]

	for combatant in combatants:
		var distance := combatant.global_position.distance_to(mouse_position)

		if distance <= 32.0:
			return combatant

	return null

func select_target(target: Combatant) -> void:
	print("Target selected: ", target.name)

	if not is_valid_target(player, target, targeting_spell):
		print("Invalid target!")
		return

	if not is_target_in_range(player, target, targeting_spell):
		print("Target is out of range!")
		return

	if not player.use_casting_resource(targeting_spell.casting_time):
		print("Cannot cast ", targeting_spell.spell_name, "!")
		return

	targeting_spell.cast(player, target)

	targeting = false
	targeting_spell = null

func is_valid_target(caster: Combatant, target: Combatant, spell: SpellData) -> bool:
	match spell.target_type:
		"Self":
			return target == caster

		"Creature":
			return true

		_:
			print("Target type not implemented yet: ", spell.target_type)
			return false

func roll_initiative() -> void:
	turn_order.clear()

	var entries: Array[InitiativeEntry] = []

	var combatants: Array[Combatant] = [
		player,
		enemy
	]

	for combatant in combatants:
		var entry := InitiativeEntry.new()

		entry.combatant = combatant
		entry.initiative = (
			randi_range(1, 20)
			+ combatant.initiative_bonus
		)

		print(
			combatant.name,
			" initiative: ",
			entry.initiative
		)

		entries.append(entry)

	entries.sort_custom(
		func(a: InitiativeEntry, b: InitiativeEntry) -> bool:
			return a.initiative > b.initiative
	)

	for entry in entries:
		turn_order.append(entry.combatant)

func start_turn() -> void:
	var combatant: Combatant = turn_order[current_turn]

	combatant.start_turn()

	print(
		"It's ",
		combatant.name,
		"'s turn! Movement: ",
		combatant.movement_remaining,
		" ft"
	)

	if combatant == player:
		player_turn()
	else:
		enemy_turn()

func player_turn() -> void:
	combat_grid.show_movement_range(
		player.grid_position,
		player.movement_remaining
	)

	print("Waiting for player input...")

func end_turn() -> void:
	var combatant: Combatant = turn_order[current_turn]

	combatant.action_available = false
	combatant.bonus_action_available = false
	combatant.reaction_available = false

	combat_grid.clear_movement_range()

	current_turn += 1

	if current_turn >= turn_order.size():
		current_turn = 0

	start_turn()

func enemy_turn() -> void:
	combat_grid.clear_movement_range()

	print("Enemy AI turn!")

	# Move toward the player if we're not already in melee range.
	var distance: int = (
		abs(enemy.grid_position.x - player.grid_position.x)
		+ abs(enemy.grid_position.y - player.grid_position.y)
	)

	if distance > 1:
		move_enemy_toward_player()

	# Check our distance again after moving.
	distance = (
		abs(enemy.grid_position.x - player.grid_position.x)
		+ abs(enemy.grid_position.y - player.grid_position.y)
	)

	# Attack if we're in melee range and still have our action.
	if distance <= 1 and enemy.action_available:
		if enemy.use_action():
			enemy.basic_attack(player)

	end_turn()

func move_enemy_toward_player() -> void:
	var current := enemy.grid_position
	var target := player.grid_position

	for i in range(enemy.movement_remaining / combat_grid.CELL_SIZE_FEET):
		# Stop moving if we're already adjacent to the player.
		var current_distance: int = (
			abs(current.x - target.x)
			+ abs(current.y - target.y)
		)

		if current_distance <= 1:
			break

		var possible_moves: Array[Vector2i] = [
			current + Vector2i(1, 0),
			current + Vector2i(-1, 0),
			current + Vector2i(0, 1),
			current + Vector2i(0, -1)
		]

		var best_cell := current
		var best_distance: int = 999999

		for cell in possible_moves:
			if not combat_grid.is_in_bounds(cell):
				continue

			if combat_grid.is_occupied(cell):
				continue

			var distance: int = (
				abs(cell.x - target.x)
				+ abs(cell.y - target.y)
			)

			if distance < best_distance:
				best_distance = distance
				best_cell = cell

		if best_cell == current:
			break

		if not combat_grid.move_combatant(enemy, best_cell):
			break

		enemy.movement_remaining -= combat_grid.CELL_SIZE_FEET
		current = best_cell

		print(
			enemy.name,
			" moved to ",
			enemy.grid_position,
			". Movement remaining: ",
			enemy.movement_remaining,
			" ft"
		)

func _on_cast_spell_button_pressed() -> void:
	var combatant := turn_order[current_turn]

	if combatant != player:
		print("It isn't the player's turn!")
		return

	if not combatant.action_available:
		print("No action available!")
		return

	test_spell.cast(player, enemy)

	combatant.action_available = false

func _on_end_turn_button_pressed() -> void:
	end_turn()

func is_target_in_range(caster: Combatant, target: Combatant, spell: SpellData) -> bool:
	var distance := caster.global_position.distance_to(target.global_position)
	var range_pixels := spell.range_feet * PIXELS_PER_FOOT

	return distance <= range_pixels
