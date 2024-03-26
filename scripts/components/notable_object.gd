class_name NotableObjectComponent
extends Component

@export var grid_bound: GridBoundComponent
var current_positions: Array[Vector3i] = []

func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		for p in current_positions:
			NotableObjects.unregister_object(p)

func _ready():
	register_component()

func register_component():
	system = NotableObjects
	system.register_component(self)

func initialize():
	current_positions.push_back(grid_bound.grid_coordinate)
	NotableObjects.register_object(target, grid_bound.grid_coordinate)

func clear_position(p: Vector3i):
	current_positions.erase(p)
	NotableObjects.unregister_object(p)

func add_position(p: Vector3i):
	current_positions.push_back(p)
	NotableObjects.register_object(target, p)
