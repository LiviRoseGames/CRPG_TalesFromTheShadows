class_name DamageEffect
extends SpellEffect

@export var dice_count: int = 1
@export var dice_size: int = 6
@export var damage_type: String = "Force"

func apply(context: SpellContext, target) -> void:
	var damage := Dice.roll_multiple(
		dice_count,
		dice_size
	)

	print("Dealing %d %s damage!" % [damage, damage_type])

	target.take_damage(damage)
