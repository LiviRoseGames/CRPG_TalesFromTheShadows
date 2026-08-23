extends Node2D
class_name Combatant

@onready var hp_label: Label = $HPLabel

@export var character_name := "Combatant"
@export var max_hp := 10
@export var initiative_bonus: int = 0

var current_hp: int

func _ready() -> void:
	current_hp = max_hp
	update_hp_display()

func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	update_hp_display()

func update_hp_display() -> void:
	hp_label.text = "%s HP: %d/%d" % [
		character_name,
		current_hp,
		max_hp
	]
