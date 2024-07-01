class_name Movable extends Node2D

signal moved(coordinates: Vector2i)

@export var cells : Array[Vector2i]
@export var cell_size : Vector2i
@export var speed : float

var is_moving : bool

# Public

func align_to_grid() -> void:
	owner.position = _compute_position_on_grid(Vector2.ZERO)


func get_coordinates() -> Vector2i:
	return (owner.position / Vector2(cell_size)).floor()


func move(direction: Vector2i) -> void:
	if not is_inside_tree():
		return

	is_moving = true

	var new_position := _compute_position_on_grid(direction)

	var tween := get_tree().create_tween()
	var distance: float = owner.position.distance_to(new_position)
	var time := distance / speed
	tween.tween_property(owner, "position", new_position, time)
	await tween.finished

	is_moving = false
	moved.emit()

# Private

func _compute_position_on_grid(direction: Vector2i) -> Vector2 :
	var coordinates := get_coordinates()
	return Vector2(coordinates + direction) * Vector2(cell_size) + (Vector2(cell_size) / 2)
