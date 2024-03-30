class_name AppMain
extends Node3D

@export var ui_layer: CanvasLayer
@export var pause_layer: CanvasLayer
@export var game_finished_layer: CanvasLayer
@export var game_level: PackedScene
@export var test_level: PackedScene

@onready var settings_scene = preload("res://scenes/ui/settings.tscn")

@onready var result_label: Label = %ResultLabel
@onready var score_container: HBoxContainer = %ScoreContainer
@onready var score_label: Label = %ScoreLabel
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var settings_window: CanvasLayer = %SettingsLayer

var is_game_running: bool = false

var level: Level

func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		if not is_game_running:
			return
		get_tree().paused = true
		pause_layer.show()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	if not game_level:
		return
	is_game_running = true
	audio_player.stop()
	var myLevel := game_level.instantiate() as Level
	myLevel.game_over.connect(on_game_over)
	myLevel.game_won.connect(on_game_won)
	add_child(myLevel)
	level = myLevel
	ui_layer.hide()

func _on_start_test_level_button_pressed():
	if not test_level:
		return
	is_game_running = true
	audio_player.stop()
	var myLevel := test_level.instantiate() as Level
	myLevel.game_over.connect(on_game_over)
	myLevel.game_won.connect(on_game_won)
	add_child(myLevel)
	level = myLevel
	ui_layer.hide()

func _on_pause_menu_quit():
	get_tree().quit()

func _on_pause_menu_resume():
	get_tree().paused = false
	pause_layer.hide()

func stop_game():
	is_game_running = false
	audio_player.play()
	Stats.force_clear()
	Obstacles.force_clear()
	Grids.force_clear()
	PlayerTrackers.force_clear()
	NotableObjects.force_clear()
	level.queue_free()

func on_game_over(reason: String):
	print("Game Over called!")
	stop_game()
	result_label.text = "Sorry, You lost the game! %s" % reason
	score_container.hide()
	game_finished_layer.show()

func on_game_won(score: int):
	print("Game Won called!")
	stop_game()
	result_label.text = "Congratulations! You won the game!"
	score_label.text = "%d" % score
	score_container.show()
	game_finished_layer.show()

func _on_pause_menu_exit_to_menu():
	get_tree().paused = false
	pause_layer.hide()
	stop_game()
	ui_layer.show()

func _on_pause_menu_settings():
	pause_layer.hide()
	settings_window.show()

func _on_gamefinished_back_button_pressed():
	game_finished_layer.hide()
	ui_layer.show()

func _on_settings_close():
	settings_window.hide()
	if is_game_running:
		pause_layer.show()
	else:
		ui_layer.show()

func _on_settings_button_pressed():
	ui_layer.hide()
	settings_window.show()

func _on_audio_stream_player_finished():
	audio_player.play(18.43)
