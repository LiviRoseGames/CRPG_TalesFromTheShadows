class_name SkillType

enum Type {
	ACROBATICS,
	ANIMAL_HANDLING,
	ARCANA,
	ATHLETICS,
	DECEPTION,
	HISTORY,
	INSIGHT,
	INTIMIDATION,
	INVESTIGATION,
	MEDICINE,
	NATURE,
	PERCEPTION,
	PERFORMANCE,
	PERSUASION,
	RELIGION,
	SLEIGHT_OF_HAND,
	STEALTH,
	SURVIVAL
}

static func get_ability(skill: Type) -> AbilityType.Type:
	match skill:
		Type.ACROBATICS:
			return AbilityType.Type.DEXTERITY

		Type.ANIMAL_HANDLING:
			return AbilityType.Type.WISDOM

		Type.ARCANA:
			return AbilityType.Type.INTELLIGENCE

		Type.ATHLETICS:
			return AbilityType.Type.STRENGTH

		Type.DECEPTION:
			return AbilityType.Type.CHARISMA

		Type.HISTORY:
			return AbilityType.Type.INTELLIGENCE

		Type.INSIGHT:
			return AbilityType.Type.WISDOM

		Type.INTIMIDATION:
			return AbilityType.Type.CHARISMA

		Type.INVESTIGATION:
			return AbilityType.Type.INTELLIGENCE

		Type.MEDICINE:
			return AbilityType.Type.WISDOM

		Type.NATURE:
			return AbilityType.Type.INTELLIGENCE

		Type.PERCEPTION:
			return AbilityType.Type.WISDOM

		Type.PERFORMANCE:
			return AbilityType.Type.CHARISMA

		Type.PERSUASION:
			return AbilityType.Type.CHARISMA

		Type.RELIGION:
			return AbilityType.Type.INTELLIGENCE

		Type.SLEIGHT_OF_HAND:
			return AbilityType.Type.DEXTERITY

		Type.STEALTH:
			return AbilityType.Type.DEXTERITY

		Type.SURVIVAL:
			return AbilityType.Type.WISDOM

	return AbilityType.Type.STRENGTH
