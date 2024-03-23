class_name Level
extends Node3D

@export var grid_map: GridMap
var mesh_library: MeshLibrary

func _ready():
	mesh_library = grid_map.mesh_library
	call_deferred(&"after_ready")

func after_ready():
	Grids.initialize()
	PlayerTrackers.initialize()

func location_exists(c: Vector3i) -> bool:
	return grid_map.get_cell_item(c) != -1

## returns true if the tile at (x, y) is a wall
## tests the name of the tile and if it has "wall" in it returns true
func is_a_wall(c: Vector3i) -> bool:
	var item := grid_map.get_cell_item(c)
	assert(item != -1, "Item has to exist")
	return mesh_library.get_item_name(item).contains("wall")
	
func map_global_to_gridcoord(c: Vector3) -> Vector3i:
	var localGridTestPoint := grid_map.to_local(c)
	return grid_map.local_to_map(localGridTestPoint)
