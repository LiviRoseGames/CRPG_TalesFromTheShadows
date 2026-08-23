extends Resource
class_name FeatureData

enum FeatureType {
	PASSIVE,
	ACTIVE,
	CHOICE,
	SUBCLASS,
	IMPROVEMENT
}

@export var feature_id: String = ""
@export var feature_name: String = ""
@export_multiline var description: String = ""
@export var feature_type: FeatureType = FeatureType.PASSIVE
