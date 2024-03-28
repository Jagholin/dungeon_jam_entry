class_name LogicTraps
extends Node3D

@export var traps: Array[Trapdoor]
@export var switches: Array[LeverA]
@export var switch_actions_0: Array[bool]
@export var switch_actions_1: Array[bool]
@export var switch_actions_2: Array[bool]
@export var switch_actions_3: Array[bool]
@export var solution: Array[bool]

func _ready():
	var actions := [switch_actions_0, switch_actions_1, switch_actions_2, switch_actions_3]
	for i in range(switches.size()):
		var s := switches[i]
		s.switched_on.connect(lever_switched.bind(i))
		s.switched_off.connect(lever_switched.bind(i))
	for i in range(traps.size()):
		var times_switched := 0
		for val_i in solution.size():
			if solution[val_i] and actions[val_i][i]:
				times_switched += 1
		if times_switched % 2 == 0:
			traps[i].close()
		else:
			traps[i].open()

func lever_switched(lever_id: int):
	var actions := [switch_actions_0, switch_actions_1, switch_actions_2, switch_actions_3]
	print("lever {0} switched".format([lever_id]))
	var action := actions[lever_id] as Array[bool]
	for i in range(action.size()):
		if action[i]:
			print("toggle trap, {0}".format([i]))
			traps[i].toggle()

