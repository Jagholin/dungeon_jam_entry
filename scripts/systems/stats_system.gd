class_name StatSystem
extends BaseSystem

var health: int:
	set(value):
		print("health set, ", value)
		var newHealth = clamp(value, 0, max_health)
		if newHealth == health:
			return
		health = newHealth
		health_changed.emit()

const default_max_health: int = 100
var max_health: int = default_max_health

enum { KEY_TYPE, UNUSED_TYPE }
class InventoryItem:
	var item_name: String
	var item_type: int
	
	func _init(n: String, t: int):
		item_name = n
		item_type = t

var inventory: Array[InventoryItem]

signal inventory_changed
signal health_changed

func reset_stats():
	max_health = default_max_health
	health = max_health
	inventory.clear()

func add_item(item_name: String, item_type: int):
	assert(item_type < UNUSED_TYPE, "Item type doesn't exist")
	inventory.push_back(InventoryItem.new(item_name, item_type))
	inventory_changed.emit()

## Removes first item with given name and type
func remove_item(item_name: String, item_type: int):
	for i in range(inventory.size()):
		if inventory[i].item_name == item_name and inventory[i].item_type == item_type:
			inventory.remove_at(i)
			inventory_changed.emit()
			return
	print("trying to remove an item that doesnt exist")
