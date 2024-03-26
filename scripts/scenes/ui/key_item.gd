class_name KeyUIItem
extends Control

@export var key_name: String

func _ready():
	%NameLabel.text = key_name
