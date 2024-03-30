class_name GateConsole
extends Node3D

@onready var teleport: MeshInstance3D = $Plane
@onready var puzzle_ui: FinalPuzzle = %FinalPuzzle
@onready var ui_layer: CanvasLayer = $UILayer
@onready var player_tracker: PlayerTrackerComponent = $PlayerTrackerComponent
var is_active: bool = false
var turned_on: bool = false

func _ready():
	teleport.hide()

func set_active(active: bool):
	is_active = active
	if is_active:
		teleport.show()
	else:
		teleport.hide()

func on_enter_teleport():
	if is_active:
		# win the game
		print("You win!")

func on_player_is_far():
	ui_layer.hide()

func _on_static_body_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if not player_tracker.player_is_close:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		ui_layer.show()
		if not turned_on:
			puzzle_ui.start_console()
			turned_on = true

func _on_final_puzzle_solution_correct():
	set_active(true)
