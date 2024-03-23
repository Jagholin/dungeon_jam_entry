class_name AppMain
extends Node3D

@export var ui_layer: CanvasLayer
@export var game_level: PackedScene

var level: Level

func _on_exit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	var myLevel := game_level.instantiate()
	add_child(myLevel)
	level = myLevel
	ui_layer.hide()
