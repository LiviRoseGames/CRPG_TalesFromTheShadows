class_name SpellCaster
extends Node

func cast_spell(
	caster,
	spell: SpellData,
	target,
	cast_circle: int = -1
) -> void:

	if cast_circle == -1:
		cast_circle = spell.circle

	var context := SpellContext.new()

	context.caster = caster
	context.spell = spell
	context.cast_circle = cast_circle
	context.primary_target = target

	for effect in spell.effects:
		effect.apply(context)
