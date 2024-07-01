extends Fantom

# Private

func _go() -> void:
	var cell := _pick_random_destination()
	go(cell)


func _pick_random_destination() -> Vector2i:
	var cell: Vector2i = _level.cells_enemies.pick_random()
	return cell

# Signals

func _on_timer_timeout() -> void:
	_go()


func _on_destination_reached():
	_go()
