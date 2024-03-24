@tool
extends Node3D

func _ready():
	if Engine.is_editor_hint():
		# add zarrow node if we are in the editor
		var sceneFile := load("res://scenes/objects/zarrow.tscn") as PackedScene
		var newChild := sceneFile.instantiate()
		add_child(newChild)
