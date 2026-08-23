class_name SpellContext
extends RefCounted

var caster
var spell: SpellData
var cast_circle: int

var primary_target
var targets: Array = []
var affected_cells: Array = []

var attack_roll: int = 0
var save_result
