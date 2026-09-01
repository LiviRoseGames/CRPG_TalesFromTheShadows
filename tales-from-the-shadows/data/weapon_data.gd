class_name WeaponData
extends Resource

@export_category("Basic Information")
@export var weapon_name: String = ""

@export_category("Damage")
@export var damage_dice_count: int = 1
@export var damage_dice_size: int = 6

@export_enum(
	"Bludgeoning",
	"Piercing",
	"Slashing"
) var damage_type: String = "Bludgeoning"

@export_category("Properties")
@export var properties: Array[String] = []

@export_category("Range")
@export var normal_range_feet: int = 5
@export var long_range_feet: int = 5

@export_category("Equipment")
@export var weight: float = 0.0
@export var cost: int = 0

func roll_damage() -> int:
	return Dice.roll_multiple(
		damage_dice_count,
		damage_dice_size
	)
