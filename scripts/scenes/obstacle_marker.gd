class_name ObstacleMarker
extends Node3D

@onready var gb: GridBoundComponent = $GridBoundComponent

func _ready():
	$CSGCylinder3D.queue_free()
	await gb.grid_coordinate_changed
	Obstacles.register_static_obstacle(gb.grid_coordinate)
