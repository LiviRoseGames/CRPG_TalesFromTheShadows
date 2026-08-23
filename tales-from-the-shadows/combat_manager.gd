extends Node2D

@onready var player = $Player
@onready var enemy = $Enemy

@export var test_spell: SpellData


func _ready() -> void:
	print("Combat started!")
	print("Player: ", player)
	print("Enemy: ", enemy)
	print("Test Spell: ", test_spell)

func _on_cast_spell_button_pressed() -> void:
	test_spell.cast(player, enemy)
