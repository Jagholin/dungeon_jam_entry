class_name PlayerTrigger
extends Node3D

signal player_entered
signal player_exited

@onready var hideme: Node3D = $hideme

@export var player_tracker: PlayerTrackerComponent

func on_player_is_close():
	player_entered.emit()

func on_player_is_far():
	player_exited.emit()

func _ready():
	hideme.hide()
