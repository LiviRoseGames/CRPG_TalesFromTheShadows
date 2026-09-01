class_name Dice


enum RollMode {
	NORMAL,
	ADVANTAGE,
	DISADVANTAGE
}


static func roll(sides: int) -> int:
	if sides <= 0:
		return 0

	return randi_range(1, sides)


static func roll_multiple(count: int, sides: int) -> int:
	var total := 0

	for i in count:
		total += roll(sides)

	return total


static func roll_d20() -> int:
	return roll(20)


static func roll_with_mode(
	sides: int,
	mode: RollMode
) -> int:
	var first_roll := roll(sides)

	match mode:
		RollMode.NORMAL:
			return first_roll

		RollMode.ADVANTAGE:
			var second_roll := roll(sides)
			return maxi(first_roll, second_roll)

		RollMode.DISADVANTAGE:
			var second_roll := roll(sides)
			return mini(first_roll, second_roll)

	return first_roll


static func roll_d20_with_mode(mode: RollMode) -> DiceResult:
	var result := DiceResult.new()

	var first := roll_d20()
	result.rolls.append(first)

	if mode == RollMode.NORMAL:
		result.total = first
		return result

	var second := roll_d20()
	result.rolls.append(second)

	if mode == RollMode.ADVANTAGE:
		result.total = maxi(first, second)
	else:
		result.total = mini(first, second)

	return result
