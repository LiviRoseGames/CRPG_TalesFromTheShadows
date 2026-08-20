extends Node

signal party_member_added(character: Character)
signal party_member_removed(character: Character)
signal player_character_changed(character: Character)

var party: Array[Character] = []
var player_character: Character

func set_player_character(character: Character) -> void:
	player_character = character

	if not party.has(character):
		party.append(character)
		party_member_added.emit(character)

	player_character_changed.emit(character)

func add_party_member(character: Character) -> void:
	if party.has(character):
		return

	party.append(character)
	party_member_added.emit(character)

func remove_party_member(character: Character) -> void:
	if character == player_character:
		return

	if not party.has(character):
		return

	party.erase(character)
	party_member_removed.emit(character)

func is_party_member(character: Character) -> bool:
	return character in party

func get_party_members() -> Array[Character]:
	return party

func get_party_size() -> int:
	return party.size()
