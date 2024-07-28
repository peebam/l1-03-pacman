@tool
class_name Pellet extends Area2D

@export var power_pellet : bool

# Called when the node enters the scene tree for the first time.
func _draw() -> void:
	var radius := 3 if power_pellet else 1
	draw_circle(Vector2.ZERO, radius, Color.WHITE)
