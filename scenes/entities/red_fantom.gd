extends Fantom

var player_coordinates : Vector2i

func _ready() -> void:
	Events.player_moved.connect(_on_Events_player_moved)

# Private

func _go() -> void:
	go(player_coordinates)

# Signals

func _on_timer_timeout() -> void:
	_go()


func _on_destination_reached():
	_go()


func _on_Events_player_moved(player_position: Vector2) -> void:
	player_coordinates = _level.position_to_coordinates(player_position) 
