class_name PlayerTrackerComponent
extends Component

const PLAYERTRACKER_COMPONENT_NAME := &"PlayerTrackerComponent"

@export var movement_listener: MovementListenerComponent
@export var grid_bound: GridBoundComponent
@export var close_distance: int

var player_is_close = false
var player_is_ontop = false

func on_player_collision():
	if target.has_method(&"on_player_collision"):
		target.on_player_collision()

func on_player_coordinate_changed(c: Vector3i):
	var dist = (grid_bound.grid_coordinate - c).abs()

	if dist.x + dist.y + dist.z == 0:
		if not player_is_ontop:
			player_is_ontop = true
			if target.has_method(&"on_player_is_ontop"):
				target.on_player_is_ontop()
	else:
		if player_is_ontop:
			player_is_ontop = false
			if target.has_method(&"on_player_is_not_ontop"):
				target.on_player_is_not_ontop()

	if dist.x + dist.y + dist.z <= close_distance:
		if not player_is_close:
			player_is_close = true
			if target.has_method(&"on_player_is_close"):
				target.on_player_is_close()
	else:
		if player_is_close:
			player_is_close = false
			if target.has_method(&"on_player_is_far"):
				target.on_player_is_far()

func _ready():
	PlayerTrackers.register_component(self)

func initialize():
	var chr := Globals.get_character_controller()
	chr.grid_movement.grid_coordinate_changed.connect(on_player_coordinate_changed)
	if movement_listener:
		movement_listener.player_collision.connect(on_player_collision)

func get_component_name() -> StringName:
	return PLAYERTRACKER_COMPONENT_NAME

func get_component_names() -> Array[StringName]:
	var temp := super.get_component_names()
	temp.push_back(PLAYERTRACKER_COMPONENT_NAME)
	return temp
