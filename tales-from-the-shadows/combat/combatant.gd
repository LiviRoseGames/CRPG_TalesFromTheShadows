extends Node2D
class_name Combatant

@onready var hp_label: Label = $HPLabel

@export var character_name := "Combatant"
@export var max_hp := 10
@export var initiative_bonus: int = 0

#@export_category("Grid")
#@export var grid_position: Vector2i

@export_category("Combat")
#@export var movement_speed: int = 30
@export var movement_speed: int = 6

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
	
	print(name, "'s resources refreshed.")

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

func can_move_to(cell: Vector2i) -> bool:
	var distance : int = abs(cell.x - grid_position.x) + abs(cell.y - grid_position.y)
	return distance <= movement_speed
