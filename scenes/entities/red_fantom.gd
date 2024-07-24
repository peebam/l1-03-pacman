extends Fantom

var player_coordinates : Vector2i

func _ready() -> void:
	Events.player_moved.connect(_on_Events_player_moved)
	super._ready()

# Public

func reset() -> void:
	super.reset()
	$AnimatedSprite2D.play("default")
	$Timer.start()

# Private

func _go() -> void:
	if _state == States.CHASING:
		go(player_coordinates)
		return

	var cell := _pick_random_destination()
	go(cell)

# Signals

func _on_timer_timeout() -> void:
	_go()


func _on_destination_reached():
	_go()


func _on_Events_player_moved(player_position: Vector2) -> void:
	player_coordinates = _level.position_to_coordinates(player_position)


func _on_destination_unreachable() -> void:
	%WanderingTimer.start()
	#_state = States.WANDERING
	_go()


func _on_wandering_timer_timeout() -> void:
	_state = States.CHASING
	_go()
