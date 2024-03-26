class_name NotableObjectsTracker
extends BaseSystem

var notable_objects: Dictionary = {}

func register_object(object: Object, coord: Vector3i) -> void:
    print("Registering object at ", coord)
    notable_objects[coord] = object

func unregister_object(coord: Vector3i) -> void:
    print("Unregistering object at ", coord)
    notable_objects.erase(coord)

func get_object(coord: Vector3i) -> Object:
    return notable_objects.get(coord, null)

func force_clear():
    super.force_clear()
    notable_objects.clear()
