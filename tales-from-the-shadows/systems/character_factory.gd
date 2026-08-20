extends Node


func create_character_data(
	creation_data: CharacterCreationData
) -> CharacterData:

	var character := CharacterData.new()

	character.character_name = creation_data.character_name
	character.character_origin = CharacterData.CharacterOrigin.PLAYER_CREATED
	character.level = 1
	character.character_class = creation_data.character_class

	character.skill_proficiencies = creation_data.skill_proficiencies.duplicate()
	character.skill_expertises = creation_data.skill_expertises.duplicate()

	for ability in AbilityType.Type.values():
		character.set_ability_score(
			ability,
			creation_data.ability_scores.get(ability, 10)
		)

	return character
