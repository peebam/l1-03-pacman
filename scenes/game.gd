class_name Game extends Node2D

signal run_failed()
signal run_won()

var _is_running := false

var _level : Level
var _level_01_scene: PackedScene = load("res://scenes/levels/level_01.tscn")
var _player_scene: PackedScene = load("res://scenes/entities/player.tscn")

# Public

func new_run() -> void:
	if _is_running:
		return
	_is_running = true

	_level = _level_01_scene.instantiate()
	add_child(_level)
	_level.position = Vector2(0, 10)

	var player = _player_scene.instantiate()
	_level.enter_player(player)

func stop_run() -> void:
	if not _is_running:
		return
	_is_running = false

	remove_child(_level)
