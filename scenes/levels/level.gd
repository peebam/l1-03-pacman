class_name Level extends Node2D

@export var player_spawn_point := Vector2.ZERO

# Public

func enter_player(player: Player) -> void:
	add_child(player)
	player.position = player_spawn_point
