class_name Teleporter
extends Node3D

@export var grid_component: GridDirectionalComponent

func activate():
	var target = grid_component.grid_coordinate
	var targetDir = grid_component.grid_direction

	var chr := Globals.get_character_controller()
	var cmp := chr.get_component(GridMovementComponent.GM_COMPONENT_NAME) as GridMovementComponent

	cmp.teleport_to(target, targetDir)
