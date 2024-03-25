class_name Level
extends Node3D

signal game_over()

@export var grid_map: GridMap
var mesh_library: MeshLibrary
@onready var hp_bar: ProgressBar = %HPBar

func _ready():
	Stats.health_changed.connect(on_health_changed)
	Stats.reset_stats()
	on_health_changed()
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


func _on_buttons_pressed(value):
	pass
	#print("You pressed the button with value, ", value)


func _on_simon_says_success():
	#pass
	print("You won the minigame! congrats")

func on_health_changed():
	if Stats.health <= 0:
		print("Game Over")
		game_over.emit()
		return
	hp_bar.value = Stats.health
	hp_bar.max_value = Stats.max_health
