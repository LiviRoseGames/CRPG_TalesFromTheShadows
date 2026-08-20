extends RefCounted
class_name CheckResult

var roll: int
var modifier: int
var total: int

var target: int = -1
var roll_state: RollState.Type = RollState.Type.NORMAL

var success: bool = false
var critical_success: bool = false
var critical_failure: bool = false
