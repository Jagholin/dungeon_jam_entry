class_name BaseSystem
extends Node

var components: Array[Component] = []

func register_component(_v):
	components.append(_v)

func unregister_component(_c):
	components.erase(_c)

func initialize():
	for c in components:
		c.initialize()

