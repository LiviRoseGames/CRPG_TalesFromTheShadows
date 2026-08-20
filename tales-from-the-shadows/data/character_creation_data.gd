extends RefCounted
class_name CharacterCreationData

var character_name: String = ""
var character_class: ClassData
var ability_scores: Dictionary = {}
var skill_proficiencies: Array[SkillType.Type] = []
var skill_expertises: Array[SkillType.Type] = []
