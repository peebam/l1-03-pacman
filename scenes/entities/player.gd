class_name Player extends CharacterBody2D

signal direction_changed()

const SPEED := 100

var _current_direction := Vector2.RIGHT :
	set = _set_current_direction
var _inputs_stack: Array[Vector2] = []

func _physics_process(delta: float) -> void:
	var input := _get_input_direction()
	if input != Vector2.ZERO and input != _current_direction:
		if _is_direction_possible(input):
			_current_direction = input

	velocity = _current_direction * 100
	move_and_slide()

	if is_on_wall():
		%AnimatedSprite.stop()
	else:
		%AnimatedSprite.play("run")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		_inputs_stack.push_front(Vector2.LEFT)
	if Input.is_action_just_released("ui_left"):
		_inputs_stack.erase(Vector2.LEFT)

	if Input.is_action_just_pressed("ui_right"):
		_inputs_stack.push_front(Vector2.RIGHT)
	if Input.is_action_just_released("ui_right"):
		_inputs_stack.erase(Vector2.RIGHT)

	if Input.is_action_just_pressed("ui_up"):
		_inputs_stack.push_front(Vector2.UP)
	if Input.is_action_just_released("ui_up"):
		_inputs_stack.erase(Vector2.UP)

	if Input.is_action_just_pressed("ui_down"):
		_inputs_stack.push_front(Vector2.DOWN)
	if Input.is_action_just_released("ui_down"):
		_inputs_stack.erase(Vector2.DOWN)

# Private

func _get_input_direction() -> Vector2:
	if _inputs_stack.is_empty():
		return Vector2.ZERO

	return _inputs_stack[0]


func _is_direction_possible(input_direction: Vector2) -> bool:
	%DirectionDetector.rotation = input_direction.angle()
	%ShapeCast.force_shapecast_update()
	return not %ShapeCast.is_colliding()


func _set_current_direction(value: Vector2) -> void:
	if value == _current_direction:
		return

	_current_direction = value
	direction_changed.emit()

# Signals

func _on_direction_changed() -> void:
	%CollisionShapeHMove.disabled = _current_direction.x == 0
	%CollisionShapeVMove.disabled = _current_direction.y == 0
	$AnimatedSprite.rotation = _current_direction.angle()

