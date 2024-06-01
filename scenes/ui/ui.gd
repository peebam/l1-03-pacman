extends CanvasLayer

signal main_menu_shown()
signal quiited()
signal run_started()

# Public

func show_main_menu() -> void:
	$MainMenu.visible = true
	$RunFailedMenu.visible = false
	$RunWonMenu.visible = false
	$HUD.visible = false


func show_game() -> void:
	$MainMenu.visible = false
	$RunFailedMenu.visible = false
	$RunWonMenu.visible = false
	$HUD.visible = true


func show_run_failed_menu() -> void:
	$MainMenu.visible = false
	$RunFailedMenu.visible = true
	$RunWonMenu.visible = false
	$HUD.visible = false


func show_run_won_menu() -> void:
	$MainMenu.visible = false
	$RunFailedMenu.visible = false
	$RunWonMenu.visible = true
	$HUD.visible = false

# Signals

func _on_main_menu_quiited() -> void:
	quiited.emit()


func _on_main_menu_run_started() -> void:
	show_game()
	run_started.emit()


func _on_run_failed_menu_main_menu() -> void:
	show_main_menu()
	main_menu_shown.emit()


func _on_run_won_menu_main_menu() -> void:
	show_main_menu()
	main_menu_shown.emit()
