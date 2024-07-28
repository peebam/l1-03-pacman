class_name Level extends TileMap

const LAYER_PATH_COMMON := 1
const LAYER_PATH_PLAYER := 2

var cells_enemies : Array[Vector2i]
var cells_player : Array[Vector2i]
var cell_size := Vector2i(8, 8)

var _astar := AStar2D.new()

func _ready() -> void:
	_compute_astar()
	cells_player = get_used_cells_by_id(LAYER_PATH_PLAYER, 5, Vector2i(1, 8))
	%OrangeFantom.start(self)
	%RedFantom.start(self)

# Public

func enter_player(player: Node2D) -> void:
	add_child(player)
	player.position = %PlayerSpawnPoint.position
	player.start(self)


func get_point_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	var from_id :=_id(from)
	var to_id :=_id(to)

	return _astar.get_point_path(from_id, to_id)


func init() -> void:
	pass


func coortinates_to_position(coordinates: Vector2i) -> Vector2:
	var position: Vector2 = coordinates * cell_size + cell_size / 2
	return position


func position_to_coordinates(position_: Vector2) -> Vector2i:
	var coordinates: Vector2 = (position_ / Vector2(cell_size)).floor()
	return coordinates

# Private

func _compute_astar() -> void:
	var neighboorhood : Array[Vector2i] = [Vector2i.DOWN, Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT]

	cells_enemies = get_used_cells_by_id(LAYER_PATH_COMMON, 5, Vector2i(1, 8))
	for cell in cells_enemies:
		_astar.add_point(_id(cell), cell)

	for cell in cells_enemies:
		for direction in neighboorhood:
			var neighboor := direction + cell
			if cells_enemies.has(neighboor):
				_astar.connect_points(_id(cell), _id(neighboor), false)


func _id(cell: Vector2) -> int:
	return cell.x * 200 + cell.y

