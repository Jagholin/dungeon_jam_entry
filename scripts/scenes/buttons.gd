class_name WallButton
extends Node3D

signal pressed(value: int)
signal highlight_finished()

@export var value: int = 0:
	set(newValue):
		if value == newValue:
			return
		value = newValue
		for i in range(button_meshes.size()):
			var button_mesh := button_meshes[i]
			if i != value:
				button_mesh.visible = false
			else:
				button_mesh.visible = true
@export var highlight_color: Color:
	set(newValue):
		if highlight_color == newValue:
			return
		highlight_color = newValue
		if highlight_spotlight:
			highlight_spotlight.light_color = highlight_color
@export_group("Internals")
@export var player_tracker: PlayerTrackerComponent
@export var button_meshes: Array[MeshInstance3D]
@export var highlight_spotlight: SpotLight3D

var highlight_on := false

func _ready():
	highlight_spotlight.light_color = highlight_color
	
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

func highlight():
	if highlight_on:
		push_warning("highlighting when highlight already on, ignoring...")
		return

	var highlightTween := create_tween()
	highlightTween.tween_property(highlight_spotlight, "light_energy", 2.0, 0.2)
	highlightTween.tween_property(highlight_spotlight, "light_energy", 0.0, 0.25)
	highlightTween.tween_callback(func():
		highlight_on = false
		highlight_finished.emit())
