extends Resource
class_name SubclassData

@export_category("Identity")
@export var subclass_name: String = ""
@export_multiline var description: String = ""

@export_category("Progression")
@export var levels: Array[ClassLevelData] = []
