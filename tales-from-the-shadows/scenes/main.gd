extends Node

func _ready() -> void:
	GameManager.start_game()
	SceneManager.change_scene("res://tests/test_scene.tscn")
