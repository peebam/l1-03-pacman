extends Area2D

@export var destination_point := Vector2.ZERO

func _on_area_entered(area):
	if area is Player:
		area.teleport(destination_point)
