class_name Game extends Node2D

signal run_failed()
signal run_won()

var _is_running := false

# Private

func new_run() -> void:
	if _is_running:
		return
	_is_running = true


func stop_run() -> void:
	if not _is_running:
		return
	_is_running = false
