class_name Dice

static func roll(sides: int = 20) -> int:
	return randi_range(1, sides)


static func roll_with_state(
	sides: int,
	state: RollState.Type
) -> int:

	var first_roll := roll(sides)

	match state:
		RollState.Type.NORMAL:
			return first_roll

		RollState.Type.ADVANTAGE:
			var second_roll := roll(sides)
			return maxi(first_roll, second_roll)

		RollState.Type.DISADVANTAGE:
			var second_roll := roll(sides)
			return mini(first_roll, second_roll)

	return first_roll
