extends Control

# Signals

func _on_run_stop_button_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "ui_cancel"
	event.pressed = true
	Input.parse_input_event(event)
