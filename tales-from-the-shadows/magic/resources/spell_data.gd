class_name SpellData
extends Resource

@export_category("Basic Information")
@export var spell_name: String
@export_multiline var description: String

@export_category("Classification")
@export_range(0, 9) var circle: int = 0

@export_enum(
	"Arcane",
	"Divine",
	"Primordial",
	"Wyrd"
) var source: String = "Arcane"

@export_enum(
	"Abjuration",
	"Conjuration",
	"Divination",
	"Enchantment",
	"Evocation",
	"Illusion",
	"Necromancy",
	"Transmutation"
) var school: String = "Evocation"

@export_category("Casting")
@export_enum(
	"Action",
	"Bonus Action",
	"Reaction",
	"Minute",
	"Hour"
) var casting_time: String = "Action"

@export var range_feet: int = 30
@export var concentration: bool = false

@export_category("Components")
@export var verbal: bool = false
@export var somatic: bool = false
@export var material: bool = false
@export var material_description: String = ""
@export var material_cost: int = 0
@export var material_consumed: bool = false

@export_category("Targeting")
@export_enum(
	"Self",
	"Creature",
	"Object",
	"Point",
	"Area"
) var target_type: String = "Creature"

@export var requires_attack_roll: bool = false

@export_enum(
	"None",
	"STR",
	"DEX",
	"CON",
	"INT",
	"WIS",
	"CHA"
) var saving_throw: String = "None"

@export_category("Ritual")
@export var is_ritual: bool = false

@export_category("Effects")
@export var effects: Array[SpellEffect] = []

func cast(caster, target) -> void:
	var context := SpellContext.new()

	context.caster = caster
	context.spell = self
	context.cast_circle = circle
	context.primary_target = target
	context.targets.append(target)

	for effect in effects:
		effect.apply(context, target)
