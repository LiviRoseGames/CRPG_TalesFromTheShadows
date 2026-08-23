extends Node
class_name Rules

static func ability_check(
	character: CharacterData,
	ability: AbilityType.Type,
	dc: int,
	roll_mode: dice.RollMode = dice.RollMode.NORMAL
) -> CheckResult:

	var dice_result := dice.roll_d20_with_mode(roll_mode)
	var result := CheckResult.new()

	result.dice_result = dice_result
	result.roll = dice_result.total
	result.modifier = character.get_ability_modifier_by_type(ability)
	result.total = result.roll + result.modifier
	result.target = dc
	result.success = result.total >= dc

	return result

static func skill_check(
	character: CharacterData,
	skill: SkillType.Type,
	dc: int,
	roll_mode: dice.RollMode = dice.RollMode.NORMAL
) -> CheckResult:

	var dice_result := dice.roll_d20_with_mode(roll_mode)
	var result := CheckResult.new()

	result.roll = dice_result.total
	result.modifier = character.get_skill_modifier(skill)
	result.total = result.roll + result.modifier
	result.target = dc
	result.success = result.total >= dc

	return result

static func saving_throw(
	character: CharacterData,
	ability: AbilityType.Type,
	dc: int,
	roll_mode: dice.RollMode = dice.RollMode.NORMAL
) -> CheckResult:

	var dice_result := dice.roll_d20_with_mode(roll_mode)
	var result := CheckResult.new()

	result.dice_result = dice_result
	result.roll = dice_result.total
	result.modifier = character.get_ability_modifier_by_type(ability)
	result.total = result.roll + result.modifier
	result.target = dc
	result.success = result.total >= dc

	return result

static func attack_roll(
	attacker: CharacterData,
	target: CharacterData,
	ability: AbilityType.Type,
	dc: int = -1,
	roll_mode: dice.RollMode = dice.RollMode.NORMAL
) -> AttackResult:

	var dice_result := dice.roll_d20_with_mode(roll_mode)
	var result := AttackResult.new()

	result.dice_result = dice_result
	result.roll = dice_result.total
	result.modifier = attacker.get_ability_modifier_by_type(ability)
	result.total = result.roll + result.modifier

	if dc < 0:
		result.target_defense = target.armor_class
	else:
		result.target_defense = dc

	result.hit = result.total >= result.target_defense

	result.critical_hit = (
		dice_result.total == 20
	)

	result.critical_miss = (
		dice_result.total == 1
	)

	return result
