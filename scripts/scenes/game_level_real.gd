class_name FirstLevel
extends Level

@export var spikes_a: Array[Spikes]
@export var spikes_b: Array[Spikes]
@export var spikes_c: Array[Spikes]

@onready var solution_components: Label = %SolutionComponents

var seconds_passed: float = 0.0
var previous_phase: int = 0

var red_decoded: bool
var green_decoded: bool
var blue_decoded: bool

func _process(delta):
	#super._process(delta)
	seconds_passed += delta
	
	var phase: int = floori(seconds_passed) % 3
	if phase != previous_phase:
		for s in spikes_a:
			if phase == 0:
				s.apply_active()
			else:
				s.apply_hidden()
		for s in spikes_b:
			if phase == 1:
				s.apply_active()
			else:
				s.apply_hidden()
		for s in spikes_c:
			if phase == 2:
				s.apply_active()
			else:
				s.apply_hidden()
	previous_phase = phase

func _on_red_entered_trigger_player_entered():
	show_note("[ZONE: RED]")

func _on_green_entered_trigger_player_entered():
	show_note("[ZONE: GREEN]")

func _on_blue_entered_trigger_player_entered():
	show_note("[ZONE: BLUE]")

func _on_lever_green_solved_switched_on():
	show_note("Green component: 122379")
	if green_decoded:
		return
	solution_components.text += "GREEN: 122379\n"
	green_decoded = true

func _on_enemy_defeated():
	show_note("Blue component: 322764")
	if blue_decoded:
		return
	solution_components.text += "BLUE: 322764\n"
	blue_decoded = true
	
func _on_simon_says_success():
	if red_decoded:
		return
	solution_components.text += "RED: 358980\n"
	red_decoded = true
