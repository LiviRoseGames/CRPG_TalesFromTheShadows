extends Node2D
class_name Combatant

@onready var hp_label: Label = $HPLabel

@export var character_name := "Combatant"
@export var max_hp := 10
@export var initiative_bonus: int = 0

#@export_category("Grid")
#@export var grid_position: Vector2i

@export_category("Combat")
@export var movement_speed: int = 30

var movement_remaining: int = 0

var action_available: bool = true
var bonus_action_available: bool = true
var reaction_available: bool = true

var current_hp: int

var grid_position: Vector2i

func _ready() -> void:
	current_hp = max_hp
	update_hp_display()

func start_turn() -> void:
	action_available = true
	bonus_action_available = true
	reaction_available = true
	movement_remaining = movement_speed
	
	print(
		name,
		"'s resources refreshed. Movement: ",
		movement_remaining
	)

func use_action() -> bool:
	if not action_available:
		return false
	
	action_available = false
	return true


func use_bonus_action() -> bool:
	if not bonus_action_available:
		return false
	
	bonus_action_available = false
	return true


func use_reaction() -> bool:
	if not reaction_available:
		return false
	
	reaction_available = false
	return true

func use_casting_resource(casting_time: String) -> bool:
	match casting_time:
		"Action":
			return use_action()

		"Bonus Action":
			return use_bonus_action()

		"Reaction":
			return use_reaction()

		"Minute", "Hour":
			print("Long casting times aren't supported in combat yet.")
			return false

		_:
			print("Unknown casting time: ", casting_time)
			return false

func basic_attack(target: Combatant) -> void:
	var damage: int = 1

	print(
		character_name,
		" attacks ",
		target.character_name,
		" for ",
		damage,
		" damage!"
	)

	target.take_damage(damage)

func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	update_hp_display()

func update_hp_display() -> void:
	hp_label.text = "%s HP: %d/%d" % [
		character_name,
		current_hp,
		max_hp
	]

func set_grid_position(position: Vector2i) -> void:
	grid_position = position

func get_movement_cost(destination: Vector2i, combat_grid) -> int:
	var cells_moved : int = (
		abs(destination.x - grid_position.x)
		+ abs(destination.y - grid_position.y)
	)

	return cells_moved * combat_grid.CELL_SIZE_FEET

func can_move_to(cell: Vector2i, combat_grid) -> bool:
	var cost := get_movement_cost(cell, combat_grid)
	return cost <= movement_remaining

func move_to_grid(cell: Vector2i, combat_grid) -> bool:
	var cost := get_movement_cost(cell, combat_grid)

	if cost > movement_remaining:
		return false

	movement_remaining -= cost

	grid_position = cell
	global_position = combat_grid.grid_to_world(cell)

	return true
