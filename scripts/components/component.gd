class_name Component
extends Node3D

var target: Node3D
var system: BaseSystem
const COMPONENT_COMPONENT_NAME := &"Component"

func _notification(what):
	if what == NOTIFICATION_PARENTED:
		target = get_parent()
	elif what == NOTIFICATION_UNPARENTED:
		target = null
	elif what == NOTIFICATION_EXIT_TREE:
		if system:
			system.unregister_component(self)

func initialize():
	pass

func get_target_3d() -> Node3D:
	return target as Node3D

# this method is just a tag to distinguish component nodes from others
func component_tag_dont_call():
	assert(false, "You are not supposed to call this function: component_tag_dont_call")

static func is_a_component(n: Node) -> bool:
	return n.has_method(&"component_tag_dont_call")

func get_component_name() -> StringName:
	return COMPONENT_COMPONENT_NAME

func get_component_names() -> Array[StringName]:
	return [COMPONENT_COMPONENT_NAME]
	
func reqister_component() -> void:
	assert(false, "this is not supposed to be called")
