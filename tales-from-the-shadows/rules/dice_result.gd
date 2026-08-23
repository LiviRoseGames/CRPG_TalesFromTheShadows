extends RefCounted
class_name DiceResult

var rolls: Array[int] = []
var total: int = 0


func is_natural_20() -> bool:
	return rolls.size() == 1 and rolls[0] == 20


func is_natural_1() -> bool:
	return rolls.size() == 1 and rolls[0] == 1
