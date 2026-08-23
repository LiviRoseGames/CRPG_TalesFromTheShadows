extends CharacterBody2D
class_name Character

signal health_changed(current_hp: int, max_hp: int)
signal character_downed
signal character_died

signal condition_added(condition: ConditionType.Type)
signal condition_removed(condition: ConditionType.Type)

@export var character_data: CharacterData

@export_category("Movement")
@export var move_speed: float = 200.0

var character_state: CharacterState


func _ready() -> void:
	if character_data == null:
		push_warning("Character has no CharacterData assigned.")
		return

	character_state = CharacterState.new()
	character_state.initialize(character_data)

	health_changed.connect(_on_health_changed)
	character_downed.connect(_on_character_downed)
	character_died.connect(_on_character_died)

	print("Character spawned: ", character_data.character_name)
	print("Level: ", character_data.level)
	print("Current HP: ", character_state.current_hp)

func _physics_process(_delta: float) -> void:
	handle_movement()
	move_and_slide()

func handle_movement() -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * move_speed

func _on_health_changed(current_hp: int, max_hp: int) -> void:
	print("HP: ", current_hp, " / ", max_hp)


func _on_character_downed() -> void:
	print("Character is DOWNED!")


func _on_character_died() -> void:
	print("Character DIED!")

func get_character_data() -> CharacterData:
	return character_data


func get_character_state() -> CharacterState:
	return character_state

func is_alive() -> bool:
	return character_state != null and not character_state.is_dead


func is_conscious() -> bool:
	return character_state != null \
		and not character_state.is_downed \
		and not character_state.is_dead

func take_damage(amount: int) -> void:
	if character_state == null:
		return

	if character_state.is_dead:
		return

	character_state.take_damage(amount)

	health_changed.emit(
		character_state.current_hp,
		character_data.get_max_hp()
	)

	if character_state.current_hp <= 0:
		if not character_state.is_downed:
			character_state.is_downed = true
			character_downed.emit()

func heal(amount: int) -> void:
	if character_state == null:
		return

	if character_state.is_dead:
		return

	character_state.heal(
		amount,
		character_data.get_max_hp()
	)

	if character_state.current_hp > 0:
		character_state.is_downed = false

	health_changed.emit(
		character_state.current_hp,
		character_data.get_max_hp()
	)

func die() -> void:
	if character_state == null:
		return

	if character_state.is_dead:
		return

	character_state.is_dead = true
	character_state.is_downed = false

	character_died.emit()

func add_condition(
	condition: ConditionType.Type,
	duration: int = -1
) -> void:
	if character_state == null:
		return

	if character_state.has_condition(condition):
		return

	character_state.add_condition(condition, duration)
	condition_added.emit(condition)


func has_condition(condition: ConditionType.Type) -> bool:
	if character_state == null:
		return false

	return character_state.has_condition(condition)

func remove_condition(condition: ConditionType.Type) -> void:
	if character_state == null:
		return

	if not character_state.has_condition(condition):
		return

	character_state.remove_condition(condition)
	condition_removed.emit(condition)
