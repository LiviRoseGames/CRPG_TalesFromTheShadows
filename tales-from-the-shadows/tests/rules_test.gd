extends Control

@onready var results_label: Label = $HBoxContainer/ResultsLabel

var test_character: CharacterData
var test_state: CharacterState



func _ready() -> void:
	test_character = preload(
		"res://data/test_character.tres"
	)

	test_state = CharacterState.new()
	test_state.initialize(test_character)

func update_resource_display() -> void:
	results_label.text = (
		"COMBAT RESOURCES\n\n"
		+ "Action: " + str(test_state.action_available) + "\n"
		+ "Bonus Action: " + str(test_state.bonus_action_available) + "\n"
		+ "Reaction: " + str(test_state.reaction_available)
	)

func _on_normal_button_pressed() -> void:
	var result := Rules.ability_check(
		test_character,
		AbilityType.Type.INTELLIGENCE,
		15
	)

	results_label.text = (
		"NORMAL CHECK\n\n"
		+ "Dice: " + str(result.dice_result.rolls) + "\n"
		+ "Used Roll: " + str(result.roll) + "\n"
		+ "Modifier: " + str(result.modifier) + "\n"
		+ "Total: " + str(result.total) + "\n"
		+ "DC: " + str(result.target) + "\n"
		+ "Success: " + str(result.success)
	)


func _on_advantage_button_pressed() -> void:
	var result := Rules.ability_check(
		test_character,
		AbilityType.Type.INTELLIGENCE,
		15,
		dice.RollMode.ADVANTAGE
	)

	results_label.text = (
		"ADVANTAGE CHECK\n\n"
		+ "Dice: " + str(result.dice_result.rolls) + "\n"
		+ "Used Roll: " + str(result.roll) + "\n"
		+ "Modifier: " + str(result.modifier) + "\n"
		+ "Total: " + str(result.total) + "\n"
		+ "DC: " + str(result.target) + "\n"
		+ "Success: " + str(result.success)
	)


func _on_disadvantage_button_pressed() -> void:
	var result := Rules.ability_check(
		test_character,
		AbilityType.Type.INTELLIGENCE,
		15,
		dice.RollMode.DISADVANTAGE
	)

	results_label.text = (
		"DISADVANTAGE CHECK\n\n"
		+ "Dice: " + str(result.dice_result.rolls) + "\n"
		+ "Used Roll: " + str(result.roll) + "\n"
		+ "Modifier: " + str(result.modifier) + "\n"
		+ "Total: " + str(result.total) + "\n"
		+ "DC: " + str(result.target) + "\n"
		+ "Success: " + str(result.success)
	)


func _on_action_button_pressed() -> void:
	var success := test_state.use_action()
	update_resource_display()


func _on_bonus_action_button_pressed() -> void:
	var success := test_state.use_bonus_action()
	update_resource_display()


func _on_reaction_button_pressed() -> void:
	var success := test_state.use_reaction()
	update_resource_display()


func _on_reset_turn_button_pressed() -> void:
	test_state.reset_turn_resources()
	update_resource_display()

func _on_saving_throw_button_pressed() -> void:
	var result := Rules.saving_throw(
		test_character,
		AbilityType.Type.DEXTERITY,
		15
	)

	results_label.text = (
		"SAVING THROW\n\n"
		+ "Dice: " + str(result.dice_result.rolls) + "\n"
		+ "Roll: " + str(result.roll) + "\n"
		+ "Modifier: " + str(result.modifier) + "\n"
		+ "Total: " + str(result.total) + "\n"
		+ "DC: " + str(result.target) + "\n"
		+ "Success: " + str(result.success)
	)

func _on_attack_button_pressed() -> void:
	var result := Rules.attack_roll(
		test_character,
		test_character,
		AbilityType.Type.STRENGTH
	)

	results_label.text = (
		"ATTACK ROLL\n\n"
		+ "Dice: " + str(result.dice_result.rolls) + "\n"
		+ "Roll: " + str(result.roll) + "\n"
		+ "Modifier: " + str(result.modifier) + "\n"
		+ "Total: " + str(result.total) + "\n"
		+ "Defense: " + str(result.target_defense) + "\n"
		+ "Hit: " + str(result.hit) + "\n"
		+ "Critical Hit: " + str(result.critical_hit) + "\n"
		+ "Critical Miss: " + str(result.critical_miss)
	)
