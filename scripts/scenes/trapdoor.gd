class_name Trapdoor
extends Node3D

## Location where the player will be teleported to when they step on the trapdoor.
@export var teleporter: Teleporter
@export_group("Internals")
@export var animation_tree: AnimationTree
@export var player_tracker: PlayerTrackerComponent

var is_transitioning: bool = false
var is_now_open: bool = false

var anim_started_was_called: bool = false

func open():
	animation_tree["parameters/conditions/open"] = true
	animation_tree["parameters/conditions/closed"] = false

func close():
	animation_tree["parameters/conditions/open"] = false
	animation_tree["parameters/conditions/closed"] = true

func initiate_fall():
	var chr := Globals.get_character_controller()
	var cmp := chr.get_component(GridMovementComponent.GM_COMPONENT_NAME) as GridMovementComponent
	cmp.apply_drop_down(teleporter)

func _on_animation_tree_animation_started(anim_name):
	# bug: AnimationTree will trigger animation_started signal twice in a row.
	# if it just happened we have to ignore it because some of our code isn't reentrant
	if anim_started_was_called:
		return
	anim_started_was_called = true
	
	if anim_name == "open_doors":
		is_transitioning = true
		is_now_open = true
		if player_tracker.player_is_ontop:
			initiate_fall()
	elif anim_name == "close_doors":
		is_transitioning = true
	else:
		assert(false, "Unknown animation name: " + anim_name)

func _on_animation_tree_animation_finished(anim_name):
	anim_started_was_called = false
	if anim_name == "open_doors":
		is_transitioning = false
	elif anim_name == "close_doors":
		is_transitioning = false
		is_now_open = false
	else:
		assert(false, "Unknown animation name: " + anim_name)

func on_player_is_ontop():
	if is_now_open:
		initiate_fall()
