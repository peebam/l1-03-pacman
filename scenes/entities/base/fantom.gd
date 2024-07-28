class_name Fantom extends Area2D

signal afraid()
signal relaxed()
signal direction_set(direction: Vector2i)

enum States {
	CHASING,
	FEARED
}

const SPEED := 50

signal destination_reached
signal destination_unreachable

@onready var _eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var _body_sprite: AnimatedSprite2D = $BodySprite
@onready var _movable: Movable = $Movable

var _level: Level
var _path : Array[Vector2i]
var _spawn_point
var _state := States.CHASING

func _ready() -> void:
	Events.power_pellet_eaten.connect(_on_Events_power_pellet_eaten)

# Public

func go(to: Vector2i) -> void:
	var from: Vector2i = _movable.get_coordinates()

	_path = []
	_path.assign(_level.get_point_path(from, to))

	if _path.is_empty():
		destination_unreachable.emit()
		return

	_next_step()


func kill() -> void:
	_movable.stop()
	position = _spawn_point


func reset() -> void:
	_movable.stop()
	position = _spawn_point


func start(level: Level) -> void:
	_level = level
	_movable.cell_size = level.cell_size
	_movable.align_to_grid()
	_spawn_point = position

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
		direction_set.emit(direction)


func _pick_random_destination() -> Vector2i:
	var cell: Vector2i = _level.cells_enemies.pick_random()
	return cell

# Signals

func _on_movable_moved():
	_next_step()


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.try_kill(self)


func _on_direction_set(direction: Vector2i) -> void:
	match direction:
		Vector2i.UP:
			_eyes_sprite.play("up")
		Vector2i.DOWN:
			_eyes_sprite.play("down")
		Vector2i.LEFT:
			_eyes_sprite.play("left")
		Vector2i.RIGHT:
			_eyes_sprite.play("right")


func _on_Events_power_pellet_eaten() -> void:
	_body_sprite.play("scared")
