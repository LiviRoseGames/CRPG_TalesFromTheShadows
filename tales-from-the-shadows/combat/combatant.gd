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
@export var armor_class: int = 10
@export var attack_bonus: int = 0

@export_category("Equipment")
@export var equipped_weapon: WeaponData


var movement_remaining: int = 0

var action_available: bool = true
var bonus_action_available: bool = true
var reaction_available: bool = true

var current_hp: int

var grid_position: Vector2i

func _ready() -> void:
	current_hp = max_hp
	update_hp_display()
	
	print(
		"Enemy weapon: ",
		equipped_weapon.weapon_name
)

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

func basic_attack(
	target: Combatant,
	combat_grid,
	roll_mode: Dice.RollMode = Dice.RollMode.NORMAL
) -> AttackResult:
	var result := AttackResult.new()

	if equipped_weapon == null:
		print(character_name, " has no weapon equipped!")
		return result

	if not is_target_in_weapon_range(target, combat_grid):
		print(
			character_name,
			" cannot attack ",
			target.character_name,
			": target is out of range."
		)
		return result

	result.dice_result = Dice.roll_d20_with_mode(roll_mode)
	result.roll = result.dice_result.total
	result.modifier = attack_bonus
	result.total = result.roll + result.modifier
	result.target_defense = target.armor_class

	result.critical_hit = result.roll == 20
	result.critical_miss = result.roll == 1

	if result.critical_miss:
		result.hit = false
	elif result.critical_hit:
		result.hit = true
	else:
		result.hit = result.total >= result.target_defense

	print(
		character_name,
		" attacks ",
		target.character_name,
		": d20 ",
		result.roll,
		" + ",
		result.modifier,
		" = ",
		result.total,
		" vs AC ",
		result.target_defense
	)

	if roll_mode != Dice.RollMode.NORMAL:
		print("Rolls: ", result.dice_result.rolls)

	if result.critical_hit:
		print("Critical Hit!")

		var damage: int = equipped_weapon.roll_damage()
		var critical_damage: int = equipped_weapon.roll_damage()

		damage += critical_damage

		print(
			"Critical! ",
			equipped_weapon.weapon_name,
			" deals ",
			damage,
			" ",
			equipped_weapon.damage_type,
			" damage!"
		)

		target.take_damage(damage)

	elif result.critical_miss:
		print("Critical Miss!")

	elif result.hit:
		var damage: int = equipped_weapon.roll_damage()

		print(
			"Hit! ",
			equipped_weapon.weapon_name,
			" deals ",
			damage,
			" ",
			equipped_weapon.damage_type,
			" damage!"
		)

		target.take_damage(damage)

	else:
		print("Miss!")
	
	return result

func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	update_hp_display()

func update_hp_display() -> void:
	hp_label.text = "%s HP: %d/%d" % [
		character_name,
		current_hp,
		max_hp
	]

func get_weapon_distance_to(target: Combatant, combat_grid) -> int:
	var cells: int = (
		abs(target.grid_position.x - grid_position.x)
		+ abs(target.grid_position.y - grid_position.y)
	)

	return cells * combat_grid.CELL_SIZE_FEET

func is_target_in_weapon_range(
	target: Combatant,
	combat_grid
) -> bool:
	if equipped_weapon == null:
		return false

	var distance: int = get_weapon_distance_to(
		target,
		combat_grid
	)

	return distance <= equipped_weapon.normal_range_feet

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
