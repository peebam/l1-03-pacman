class_name Player extends Area2D

enum States {
	ALIVE,
	EXCITED,
	DEAD
}

signal state_changed()
signal direction_changed()
signal killed()

var _cells : Array[Vector2i]
var _current_direction := Vector2.RIGHT :
	set = _set_current_direction
var _inputs_stack: Array[Vector2] = []
var _state := States.ALIVE :
	set = _set_state


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
	%Movable.cell_size = level.cell_size
	%Movable.align_to_grid()


func teleport(position_: Vector2) -> void:
	position = position_
	%Movable.stop()
	%Movable.align_to_grid()


func try_kill(phantom: Fantom) -> void:
	if not _state == States.EXCITED:
		_state = States.DEAD
	else:
		phantom.kill()

# Private

func _get_input_direction() -> Vector2:
	if _inputs_stack.is_empty():
		return Vector2.ZERO

	return _inputs_stack[0]


func _is_direction_possible(input_direction: Vector2) -> bool:
	return true


func _is_move_possible(direction: Vector2i) -> bool:
	var coordinates: Vector2i = direction + %Movable.get_coordinates()
	var move_possible := _cells.has(coordinates)
	return move_possible


func _set_current_direction(value: Vector2) -> void:
	if value == _current_direction:
		return

	_current_direction = value
	direction_changed.emit()


func _set_state(value: States) -> void:
	if value == _state:
		return

	_state = value
	state_changed.emit()


func _try_move() -> void:
	if _state == States.DEAD:
		return

	if %Movable.is_moving:
		return

	var direction := _get_input_direction()
	if direction != Vector2.ZERO:
		if _is_move_possible(direction):
			_current_direction = direction

	if _is_move_possible(_current_direction):
		%Movable.move(_current_direction)
	else:
		_current_direction = Vector2.ZERO

# Signals

func _on_animated_sprite_animation_finished() -> void:
	if  %AnimatedSprite.animation == "die":
		Events.player_killed.emit()
		queue_free()


func _on_direction_changed() -> void:
	if _current_direction == Vector2.ZERO:
		%AnimatedSprite.stop()
		return

	rotation = _current_direction.angle()
	%AnimatedSprite.play("run")


func _on_excited_timer_timeout() -> void:
	pass # Replace with function body.


func _on_movable_moved():
	Events.player_moved.emit(position)
	_try_move()


func _on_pellet_dectector_area_entered(area: Area2D) -> void:
	if area is Pellet:
		if area.power_pellet:
			_state = States.EXCITED
			Events.power_pellet_eaten.emit()
		area.queue_free()


func _on_state_changed() -> void:
	if _state == States.DEAD:
		%AnimatedSprite.play("die")
		killed.emit()

	if _state == States.ALIVE:
		%AnimatedSprite.play("run")
		%AnimatedSprite.speed_scale = 1.0


	if _state == States.EXCITED:
		%AnimatedSprite.play("run")
		%AnimatedSprite.speed_scale = 2

