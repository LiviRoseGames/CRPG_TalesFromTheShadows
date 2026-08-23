extends Node

@onready var spell_caster: SpellCaster = $SpellCaster

var test_spell = preload("res://magic/data/spells/test_spell.tres")

func _ready() -> void:
	var caster = "Lulen"
	var target = "Goblin"

	spell_caster.cast_spell(
		caster,
		test_spell,
		target
	)
