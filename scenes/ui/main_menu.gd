extends Control

signal quiited()
signal run_started()

# Signals

func _on_new_run_button_pressed() -> void:
	run_started.emit()


func _on_quit_button_pressed() -> void:
	quiited.emit()

