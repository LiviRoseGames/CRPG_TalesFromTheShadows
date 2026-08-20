extends Resource
class_name CharacterData

#const AbilityType = preload("res://data/ability_type.gd")

@export_category("Identity")
@export var character_name: String = ""
@export var description: String = ""

@export_category("Progression")
@export var level: int = 1

@export_category("Class")
@export var character_class: ClassData

@export_category("Ability Scores")
@export var strength: int = 10
@export var dexterity: int = 10
@export var constitution: int = 10
@export var intelligence: int = 10
@export var wisdom: int = 10
@export var charisma: int = 10

@export_category("Proficiencies")
@export var skill_proficiencies: Array[SkillType.Type] = []

@export var skill_expertises: Array[SkillType.Type]

#Skills
func get_skill_modifier(skill: SkillType.Type) -> int:
	var ability := SkillType.get_ability(skill)
	var modifier := get_ability_modifier_by_type(ability)
	var proficiency_bonus := get_proficiency_bonus()

	if has_expertise_in_skill(skill):
		modifier += proficiency_bonus * 2

	elif is_proficient_in_skill(skill):
		modifier += proficiency_bonus

	return modifier

#Proficiencies
func get_proficiency_bonus() -> int:
	return 2 + floori((level - 1) / 4.0)

func is_proficient_in_skill(skill: SkillType.Type) -> bool:
	return skill in skill_proficiencies or has_expertise_in_skill(skill)

func has_expertise_in_skill(skill: SkillType.Type) -> bool:
	return skill in skill_expertises

#Ability Scores
func get_ability_score(ability: AbilityType.Type) -> int:
	match ability:
		AbilityType.Type.STRENGTH:
			return strength
		AbilityType.Type.DEXTERITY:
			return dexterity
		AbilityType.Type.CONSTITUTION:
			return constitution
		AbilityType.Type.INTELLIGENCE:
			return intelligence
		AbilityType.Type.WISDOM:
			return wisdom
		AbilityType.Type.CHARISMA:
			return charisma

	return 0

func get_ability_modifier_by_type(ability: AbilityType.Type) -> int:
	return get_ability_modifier(get_ability_score(ability))

func get_ability_modifier(score: int) -> int:
	return floori((score - 10) / 2.0)

func get_strength_modifier() -> int:
	return get_ability_modifier(strength)

func get_dexterity_modifier() -> int:
	return get_ability_modifier(dexterity)

func get_constitution_modifier() -> int:
	return get_ability_modifier(constitution)

func get_intelligence_modifier() -> int:
	return get_ability_modifier(intelligence)

func get_wisdom_modifier() -> int:
	return get_ability_modifier(wisdom)

func get_charisma_modifier() -> int:
	return get_ability_modifier(charisma)
