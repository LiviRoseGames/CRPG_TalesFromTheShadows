extends RefCounted
class_name CharacterState

var current_hp: int = 0
var temporary_hp: int = 0

var is_downed: bool = false
var is_dead: bool = false

var conditions: Array[ConditionState] = []

func initialize(character_data: CharacterData) -> void:
	current_hp = character_data.get_max_hp()
	temporary_hp = 0

func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	if temporary_hp > 0:
		var absorbed := mini(temporary_hp, amount)

		temporary_hp -= absorbed
		amount -= absorbed

	current_hp -= amount

func heal(amount: int, max_hp: int) -> void:
	if amount <= 0:
		return

	current_hp = mini(current_hp + amount, max_hp)

func get_condition(condition: ConditionType.Type) -> ConditionState:
	for active_condition in conditions:
		if active_condition.condition == condition:
			return active_condition

	return null

func add_condition(condition: ConditionType.Type, duration: int = -1) -> void:
	if has_condition(condition):
		return

	var new_condition := ConditionState.new()
	new_condition.condition = condition
	new_condition.duration = duration

	conditions.append(new_condition)

func has_condition(condition: ConditionType.Type) -> bool:
	for active_condition in conditions:
		if active_condition.condition == condition:
			return true

	return false

func remove_condition(condition: ConditionType.Type) -> void:
	for i in range(conditions.size() - 1, -1, -1):
		if conditions[i].condition == condition:
			conditions.remove_at(i)
