extends Node

func make_skill_check(
	character: CharacterData,
	skill: SkillType.Type,
	difficulty: int,
	roll_mode: Dice.RollMode = Dice.RollMode.NORMAL
) -> CheckResult:
	
	var result := CheckResult.new()

	result.roll_state = roll_mode
	result.roll = Dice.roll_with_mode(20, roll_mode)
	result.modifier = character.get_skill_modifier(skill)
	result.total = result.roll + result.modifier
	result.target = difficulty

	result.success = result.total >= difficulty

	result.critical_success = result.roll == 20
	result.critical_failure = result.roll == 1

	return result
