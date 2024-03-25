class_name LeverA
extends Node3D

signal switched_on()
signal switched_off()
signal value_changed(val: bool)

@export var on_by_default: bool = false
@export var switching_speed: float = 1.0

@onready var player_tracker: PlayerTrackerComponent = $PlayerTrackerComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var value: bool = false
var is_transitioning: bool = false
var switching_state_to: bool = false:
	set(newValue):
		if newValue == switching_state_to:
			return
		switching_state_to = newValue
		animation_tree["parameters/conditions/on"] = newValue
		animation_tree["parameters/conditions/off"] = not newValue

func switching_on():
	value = true
	switched_on.emit()
	value_changed.emit(true)
	is_transitioning = true
func has_switched_on():
	is_transitioning = false
func switching_off():
	value = false
	switched_off.emit()
	value_changed.emit(false)
	is_transitioning = true
func has_switched_off():
	is_transitioning = false

func _ready():
	animation_player.speed_scale = switching_speed
	switching_state_to = on_by_default

func _on_static_body_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	print("event caught")
	if is_transitioning:
		return
	if not player_tracker.player_is_close:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		switching_state_to = not switching_state_to
