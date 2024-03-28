class_name FinalPuzzle
extends PanelContainer

signal solution_correct()
signal solution_false()

@onready var timer: Timer = $Timer
@onready var label: Label = %TerminalLabel
@onready var input_box: BoxContainer = %InputBox
@onready var input_sol: LineEdit = %FreqInput

@export var solution: int

const lines_visible_breakpoints = [1, 2, 3, 5, 7, 10, 13]
var visible_lines_index = 0

func _ready():
	start_console()

func start_console():
	timer.start()
	visible_lines_index = 0
	label.max_lines_visible = 1

func _on_timer_timeout():
	label.max_lines_visible = lines_visible_breakpoints[visible_lines_index]
	visible_lines_index += 1
	label.text += " "
	if label.max_lines_visible == label.get_line_count():
		timer.stop()
		activate_input()

func activate_input():
	input_box.show()

func _on_confirm_pressed():
	input_sol.text = ""
	if input_sol.text.to_int() == solution:
		solution_correct.emit()
	else:
		solution_false.emit()
