class_name Player extends Area2D

signal direction_changed()

@onready var _movable : Movable = $Movable

var _cells : Array[Vector2i]
var _current_direction := Vector2.RIGHT :
	set = _set_current_direction
var _inputs_stack: Array[Vector2] = []


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		_inputs_stack.push_front(Vector2.LEFT)
	if Input.is_action_just_released("ui_left"):
		_inputs_stack = _inputs_stack.filter(func(f): return f != Vector2.LEFT)

	if Input.is_action_just_pressed("ui_right"):
		_inputs_stack.push_front(Vector2.RIGHT)
	if Input.is_action_just_released("ui_right"):
		_inputs_stack = _inputs_stack.filter(func(f): return f != Vector2.RIGHT)

	if Input.is_action_just_pressed("ui_up"):
		_inputs_stack.push_front(Vector2.UP)
	if Input.is_action_just_released("ui_up"):
		_inputs_stack = _inputs_stack.filter(func(f): return f != Vector2.UP)

	if Input.is_action_just_pressed("ui_down"):
		_inputs_stack.push_front(Vector2.DOWN)
	if Input.is_action_just_released("ui_down"):
		_inputs_stack = _inputs_stack.filter(func(f): return f != Vector2.DOWN)


func _process(delta) -> void:
	_try_move()

# Public

func start(level: Level) -> void:
	_cells = level.cells_player
	_movable.cell_size = level.cell_size
	_movable.align_to_grid()

# Private

func _get_input_direction() -> Vector2:
	if _inputs_stack.is_empty():
		return Vector2.ZERO

	return _inputs_stack[0]


func _is_direction_possible(input_direction: Vector2) -> bool:
	return true


func _is_move_possible(direction: Vector2i) -> bool:
	if _movable.is_moving:
		return false

	var coordinates := direction + _movable.get_coordinates()
	var move_possible := _cells.has(coordinates)
	return move_possible


func _set_current_direction(value: Vector2) -> void:
	if value == _current_direction:
		return

	_current_direction = value
	direction_changed.emit()


func _try_move() -> void:
	var direction := _get_input_direction()
	if direction != Vector2.ZERO:
		if _is_move_possible(direction):
			_current_direction = direction

	if _is_move_possible(_current_direction):
		_movable.move(_current_direction)
		%AnimatedSprite.play("run")

# Signals

func _on_direction_changed() -> void:
	$AnimatedSprite.rotation = _current_direction.angle()


func _on_movable_moved():
	Events.player_moved.emit(position)
	_try_move()


func _on_pellet_dectector_area_entered(area: Area2D) -> void:
	if area is Pellet:
		area.queue_free()
