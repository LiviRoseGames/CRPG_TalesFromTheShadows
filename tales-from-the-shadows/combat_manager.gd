extends Node2D

@onready var player = $Player
@onready var enemy = $Enemy

@export var test_spell: SpellData

var turn_order: Array[Combatant] = []
var current_turn: int = 0


func _ready() -> void:
	print("Combat started!")
	#print("Player: ", player)
	#print("Enemy: ", enemy)
	#print("Test Spell: ", test_spell)
	
	roll_initiative()

	start_turn()


func roll_initiative() -> void:
	turn_order.clear()

	var entries: Array[InitiativeEntry] = []

	var combatants: Array[Combatant] = [
		player,
		enemy
	]

	for combatant in combatants:
		var entry := InitiativeEntry.new()

		entry.combatant = combatant
		entry.initiative = (
			randi_range(1, 20)
			+ combatant.initiative_bonus
		)

		print(
			combatant.name,
			" initiative: ",
			entry.initiative
		)

		entries.append(entry)

	entries.sort_custom(
		func(a: InitiativeEntry, b: InitiativeEntry) -> bool:
			return a.initiative > b.initiative
	)

	for entry in entries:
		turn_order.append(entry.combatant)

func start_turn() -> void:
	var combatant := turn_order[current_turn]

	combatant.start_turn()

	print("It's ", combatant.name, "'s turn!")

func end_turn() -> void:
	current_turn += 1

	if current_turn >= turn_order.size():
		current_turn = 0

	start_turn()

func _on_cast_spell_button_pressed() -> void:
	var combatant := turn_order[current_turn]

	if combatant != player:
		print("It isn't the player's turn!")
		return

	if not player.use_casting_resource(test_spell.casting_time):
		print("Cannot cast ", test_spell.spell_name, "!")
		return

	test_spell.cast(player, enemy)

func _on_end_turn_button_pressed() -> void:
	end_turn()
