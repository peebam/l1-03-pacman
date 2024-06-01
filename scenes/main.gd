extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$Game.stop_run()
		$Ui.show_main_menu()

# Signals

func _on_game_run_failed() -> void:
	$Game.stop_run()
	$Ui.show_run_failed_menu()


func _on_game_run_won() -> void:
	$Game.stop_run()
	$Ui.show_run_won_menu()


func _on_ui_main_menu_shown() -> void:
	$Game.stop_run()
	$Ui.show_main_menu()


func _on_ui_quiited() -> void:
	get_tree().quit()


func _on_ui_run_started() -> void:
	$Game.new_run()
	$Ui.show_game()


func _on_run_stopped() -> void:
	$Game.stop_run()
	$Ui.show_main_menu()
