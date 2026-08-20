extends Node

func change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file.call_deferred(scene_path)
