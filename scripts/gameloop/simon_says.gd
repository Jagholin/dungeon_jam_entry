class_name SimonSays
extends Node3D

signal success
signal highlight_finished

@export var secret: Array[int]
## Camera that is positioned in a way that the player can see all buttons
@export var overview_camera: Camera3D
## Array of buttons 0-9. All indices from 0 to 9 must exist, but can be empty(null).
@export var buttons: Array[WallButton]
@export_group("Internals")
@export var highlight_timer: Timer

## What button must be pressed next
var current_index: int = 0
## Last button that has to be pressed in the current round
var current_remembered_index: int = 0

var game_is_active: bool = false
var was_solved: bool = false

func _ready():
	for button in buttons:
		if button:
			button.pressed.connect(button_pressed)

func start_game():
	if was_solved:
		return
	if game_is_active:
		return
	game_is_active = true
	current_index = 0
	current_remembered_index = 0
	run_highlight_sequence()

func button_pressed(value: int):
	if not game_is_active:
		return
	if secret[current_index] == value:
		current_index += 1
		if current_index == secret.size():
			current_index = 0
			current_remembered_index = 0
			game_is_active = false
			was_solved = true
			success.emit()
			return
		if current_index > current_remembered_index:
			current_remembered_index += 1
			current_index = 0
			run_highlight_sequence()
	else:
		current_index = 0
		current_remembered_index = 0
		run_highlight_sequence()

func run_highlight_sequence():
	var chr := Globals.get_character_controller()
	chr.look_through(overview_camera, highlight_finished)
	chr.enable_spotlight = false

	for i in range(current_remembered_index + 1):
		buttons[secret[i]].highlight()
		await buttons[secret[i]].highlight_finished

		## wait for a bit
		highlight_timer.start()
		await highlight_timer.timeout
	
	chr.enable_spotlight = true
	highlight_finished.emit()
