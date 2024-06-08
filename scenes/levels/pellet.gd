@tool
class_name Pellet extends Area2D


# Called when the node enters the scene tree for the first time.
func _draw() -> void:
	draw_circle(Vector2.ZERO, 1, Color.WHITE)
