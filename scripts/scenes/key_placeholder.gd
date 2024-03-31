class_name KeyItem
extends Node3D

@onready var grid_bound: GridBoundComponent = $GridBoundComponent
@onready var player_tracker: PlayerTrackerComponent = $PlayerTrackerComponent
@onready var audio_player: AudioStreamPlayer3D = %AudioStreamPlayer3D

@export var item_name: String = "key_a"

signal item_pickup(name: String)
func emit_pickup_signal():
	item_pickup.emit(item_name)

func _on_static_body_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if not player_tracker.player_is_close:
		return
	if event is InputEventMouseButton:
		var realEvent := event as InputEventMouseButton
		if realEvent.button_index == MOUSE_BUTTON_LEFT and realEvent.pressed:
			print("you clicked on the thing")
			Stats.add_item(item_name, StatSystem.KEY_TYPE)
			audio_player.play()
			emit_pickup_signal()
			hide()

func _on_audio_stream_player_3d_finished():
	# destroy the item
	queue_free()
