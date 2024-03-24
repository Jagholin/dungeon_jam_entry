class_name WallButton
extends Node3D

signal pressed(value: int)

@export var value: int = 0:
	set(newValue):
		value = newValue
		for i in range(button_meshes.size()):
			var button_mesh := button_meshes[i]
			if i != value:
				button_mesh.visible = false
			else:
				button_mesh.visible = true

@export_group("Internals")
@export var player_tracker: PlayerTrackerComponent
@export var button_meshes: Array[MeshInstance3D]

func _ready():
	for i in range(button_meshes.size()):
		var button_mesh := button_meshes[i]
		button_mesh.position = Vector3.ZERO
		if i != value:
			button_mesh.visible = false
		else:
			button_mesh.visible = true
		
		var physicsBody := button_mesh.get_node("StaticBody3D") as StaticBody3D
		physicsBody.input_event.connect(_on_button_input)

func _on_button_input(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if not player_tracker.player_is_close:
		return

	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			pressed.emit(value)
