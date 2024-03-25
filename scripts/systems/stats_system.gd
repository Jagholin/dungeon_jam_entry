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

signal health_changed

func reset_stats():
	max_health = default_max_health
	health = max_health
