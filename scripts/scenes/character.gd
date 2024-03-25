class_name CharacterController
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var step_sound_player: AudioStreamPlayer = $StepSoundsPlayer
@onready var grid_movement: GridMovementComponent = $GridMovementComponent

@export_group("Internals")
@export var camera_swap_timer: Timer
@export var camera: Camera3D

enum MovementCommand { LEFT_COMMAND, RIGHT_COMMAND, FORWARD_COMMAND, BACK_COMMAND, STRAFE_LEFT_COMMAND, STRAFE_RIGHT_COMMAND }
const movement_dictionary := {
	"forward" = MovementCommand.FORWARD_COMMAND,
	"backward" = MovementCommand.BACK_COMMAND,
	"left" = MovementCommand.LEFT_COMMAND,
	"right" = MovementCommand.RIGHT_COMMAND,
	"strafe_left" = MovementCommand.STRAFE_LEFT_COMMAND,
	"strafe_right" = MovementCommand.STRAFE_RIGHT_COMMAND,
}
var movement_functions := {
	MovementCommand.FORWARD_COMMAND: func(g): g.move_forward(),
	MovementCommand.BACK_COMMAND: func(g): g.move_backward(),
	MovementCommand.LEFT_COMMAND: func(g): g.rotate_left(),
	MovementCommand.RIGHT_COMMAND: func(g): g.rotate_right(),
	MovementCommand.STRAFE_LEFT_COMMAND: func(g): g.strafe_left(),
	MovementCommand.STRAFE_RIGHT_COMMAND: func(g): g.strafe_right(),
}
var command_queue: Array[MovementCommand] = []

const KEY_ITEM_NAME := "KEY"
var inventory = []

func coord_to_position(c: Vector3i) -> Vector3:
	return Vector3(c.x * 2 + 1.0, 0.0, c.z * 2 + 1.0)
	
func dir_to_rotation(c: Vector3i) -> Vector3:
	if c.z == -1:
		return Vector3(0, 0, 0)
	elif c.x == -1:
		return Vector3(0, PI / 2.0, 0)
	elif c.z == 1:
		return Vector3(0, PI, 0)
	elif c.x == 1:
		return Vector3(0, 3.0 * PI / 2.0, 0)
	push_error("Unexpected direction value, {0}".format([c]))
	return Vector3(0, 0, 0)
	
func _input(_event):
	# limit command queue to 1 command
	if command_queue.size() >= 1:
		return
	for c in movement_dictionary:
		if Input.is_action_just_pressed(c):
			command_queue.push_back(movement_dictionary[c])
	
func _process(_delta):
	if grid_movement.movement_state != GridMovementComponent.IDLE_STATE:
		return
	var next_command: MovementCommand
	if command_queue.is_empty():
		# special case: if the queue is empty, but the player still holds the 
		# movement button, execute that movement immediately
		var pressedCommands: Array[MovementCommand] = []
		for c in movement_dictionary:
			if Input.is_action_pressed(c):
				pressedCommands.push_back(movement_dictionary[c])
		
		if pressedCommands.size() != 1:
			return
		next_command = pressedCommands[0]
	else:
		next_command = command_queue.pop_front() as MovementCommand

	movement_functions[next_command].call(grid_movement)
	
func on_item_pickup(item_name: String):
	#print("Item added: {0}".format([item_name]))
	Globals.get_current_level().show_notice("You picked up: {0}".format([item_name]))
	inventory.push_back(item_name)
	
#func try_open_door(d: Door) -> bool:
	#var key_item = inventory.find(KEY_ITEM_NAME)
	#if key_item == -1:
		#return false
	#d.open_door()
	#inventory.remove_at(key_item)
	#return true

func get_component(componentClassName: StringName) -> Component:
	for c in get_children():
		if Component.is_a_component(c) and componentClassName in c.get_component_names():
			return c as Component
	return null

func look_through(cam: Camera3D, stop_signal: Signal) -> void:
	cam.make_current()
	await stop_signal
	camera.make_current()
