class_name Door
extends Node3D

@export var grid_bound: GridBoundComponent
@export var player_tracker: PlayerTrackerComponent
@export var animation_tree: AnimationTree
@export var close_timer: Timer
@export var wait_close_interval: float = 3.0
@export var wait_close_hurry_interval: float = 1.0
var is_open: bool = false
var is_transitioning: bool = false

func on_movement_initiated() -> MovementListenerComponent.MovementEffect:
	return MovementListenerComponent.MovementEffect.NONE if is_open and not is_transitioning \
		else MovementListenerComponent.MovementEffect.PREVENT_MOVEMENT

func door_is_opening():
	is_transitioning = true

func door_has_opened():
	is_open = true
	is_transitioning = false
	close_timer.wait_time = wait_close_interval
	close_timer.start()

func door_is_closing():
	is_open = false
	is_transitioning = true

func door_has_closed():
	is_transitioning = false

func attempt_close_door():
	assert(is_open and not is_transitioning)
	if not player_tracker.player_is_ontop:
		animation_tree["parameters/conditions/open"] = false
	else:
		close_timer.wait_time = wait_close_hurry_interval
		close_timer.start()

func _on_static_body_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if not player_tracker.player_is_close:
		return
	if not is_open and not is_transitioning and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# initiate door opening
		animation_tree["parameters/conditions/open"] = true
