extends Node

@export var character_data: CharacterData

func _ready() -> void:
	print("Character: ", character_data.character_name)
	print("Level: ", character_data.level)

	print("Proficiency Bonus: ", character_data.get_proficiency_bonus())

	if character_data.character_class:
		print("Class: ", character_data.character_class.character_class_name)

	print("Strength: ", character_data.strength)
	print("Dexterity: ", character_data.dexterity)
	print("Charisma: ", character_data.charisma)

	print("Strength Modifier: ", character_data.get_strength_modifier())
	print("Dexterity Modifier: ", character_data.get_dexterity_modifier())
	print("Charisma Modifier: ", character_data.get_charisma_modifier())

	print(
	"Persuasion Proficient: ",
	character_data.is_proficient_in_skill(
		SkillType.Type.PERSUASION
		)
	)

	print(
	"Persuasion Modifier: ",
	character_data.get_skill_modifier(
		SkillType.Type.PERSUASION
		)
	)

	var persuasion_result := RulesManager.make_skill_check(
		character_data,
		SkillType.Type.PERSUASION,
		15
	)
	
	print("----- PERSUASION CHECK -----")
	print("Roll: ", persuasion_result.roll)
	print("Modifier: ", persuasion_result.modifier)
	print("Total: ", persuasion_result.total)
	print("Target: ", persuasion_result.target)
	print("Success: ", persuasion_result.success)
	print("Critical Success: ", persuasion_result.critical_success)
	print("Critical Failure: ", persuasion_result.critical_failure)
	
