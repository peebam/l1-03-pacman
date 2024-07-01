class_name Fantom extends Area2D

const SPEED := 50

signal destination_reached

@onready var _movable : Movable = $Movable

var _level: Level
var _path : Array[Vector2i]

# Public

func start(level: Level) -> void:
	_level = level
	_movable.cell_size = level.cell_size
	_movable.align_to_grid()


func go(to: Vector2i) -> void:
	var from: Vector2i = _movable.get_coordinates()

	_path = []
	_path.assign(_level.get_point_path(from, to))
	_next_step()

# Private

func _next_step() -> void:
	if _path.is_empty():
		destination_reached.emit()
		return

	if not _movable.is_moving:
		var coordinates: Vector2 = _path.pop_front()
		var point := _level.coortinates_to_position(coordinates)
		var direction = position.direction_to(point)
		_movable.move(direction)


func _on_movable_moved():
	_next_step()
