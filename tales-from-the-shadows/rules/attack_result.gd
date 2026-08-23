extends RefCounted
class_name AttackResult

var dice_result: DiceResult

var roll: int = 0
var modifier: int = 0
var total: int = 0

var target_defense: int = 0

var hit: bool = false
var critical_hit: bool = false
var critical_miss: bool = false
