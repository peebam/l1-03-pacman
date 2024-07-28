extends Fantom

# Public

func reset() -> void:
	super.reset()
	$AnimatedSprite2D.play("default")
	$Timer.start()

# Private

func _go() -> void:
	var cell := _pick_random_destination()
	go(cell)

# Signals

func _on_timer_timeout() -> void:
	_go()


func _on_destination_reached():
	_go()
