class_name SettingsWindow
extends CenterContainer

signal close

@onready var immediate_checkbox: CheckBox = %ImmediateMoveCheckBox

class BtnLabelPair:
	var btn: Button
	var label: Label

	func _init(b: Button, l: Label):
		btn = b
		label = l

var action_names: Dictionary

var is_changing_action: bool = false
var changing_action: String

func fill_action_names():
	action_names = {
		"forward": BtnLabelPair.new(%FwdButton, %FwdLabel),
		"backward": BtnLabelPair.new(%BackButton, %BackLabel),
		"left": BtnLabelPair.new(%LeftButton, %LeftLabel),
		"right": BtnLabelPair.new(%RightButton, %RightLabel),
		"strafe_left": BtnLabelPair.new(%StrafeLeftButton, %StrafeLeftLabel),
		"strafe_right": BtnLabelPair.new(%StrafeRightButton, %StrafeRightLabel),
		"attack": BtnLabelPair.new(%AttackButton, %AttackLabel),
	}

func _unhandled_input(event):
	if is_changing_action:
		if event is InputEventKey:
			InputMap.action_add_event(changing_action, event)
			action_names[changing_action].label.text = event.as_text()
			is_changing_action = false
			changing_action = ""

func _on_action_button_pressed(action: String):
	InputMap.action_erase_events(action)
	is_changing_action = true
	changing_action = action
	action_names[action].label.text = "Press a key"

func _ready():
	fill_action_names()
	immediate_checkbox.button_pressed = Grids.immediate_movement
	for action in action_names:
		action_names[action].label.text = InputMap.action_get_events(action)[0].as_text()
		action_names[action].btn.pressed.connect(_on_action_button_pressed.bind(action))

func _on_close_button_pressed():
	#queue_free()
	close.emit()

func _on_immediate_move_check_box_toggled(toggled_on):
	Grids.immediate_movement = toggled_on
