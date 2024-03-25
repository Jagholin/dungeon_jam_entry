class_name AppMain
extends Node3D

@export var ui_layer: CanvasLayer
@export var pause_layer: CanvasLayer
@export var game_level: PackedScene
@export var test_level: PackedScene

var level: Level

func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		if ui_layer.visible:
			return
		get_tree().paused = true
		pause_layer.show()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	if not game_level:
		return
	var myLevel := game_level.instantiate()
	add_child(myLevel)
	level = myLevel
	ui_layer.hide()

func _on_start_test_level_button_pressed():
	if not test_level:
		return
	var myLevel := test_level.instantiate()
	add_child(myLevel)
	level = myLevel
	ui_layer.hide()

func _on_pause_menu_quit():
	get_tree().quit()

func _on_pause_menu_resume():
	get_tree().paused = false
	pause_layer.hide()
