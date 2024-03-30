class_name Enemy
extends Node3D

signal defeated
signal health_changed
signal player_is_close
signal player_is_far

@onready var movement: AIMovementComponent = $GridMovementComponent
@onready var entity: RawEnemyBlack = $enemy_black
@export var attack_strength: int = 10
@export var max_health: int = 100
var _health: int:
	set(value):
		if value == _health:
			return
		_health = value
		health_changed.emit()
		if _health <= 0:
			defeated.emit()
			queue_free()

func coord_to_position(c: Vector3i) -> Vector3:
	return Vector3(c.x * 2 + 1.0, position.y, c.z * 2 + 1.0)
	
func dir_to_rotation(c: Vector3i) -> Vector3:
	if c.z == -1:
		return Vector3(0, 0, 0)
	elif c.x == -1:
		return Vector3(0, PI / 2.0, 0)
	elif c.z == 1:
		return Vector3(0, PI, 0)
	elif c.x == 1:
		return Vector3(0, 3.0 * PI / 2.0, 0)
	push_error("Unexpected direction value, {0}".format([c]))
	return Vector3(0, 0, 0)

func _ready():
	# await get_tree().create_timer(1.0).timeout
	_health = max_health

func attempt_attack():
	entity.start_attack_anim()

func attempt_hit():
	var cmp := Globals.get_character_controller().get_component(GridBoundComponent.GB_COMPONENT_NAME) as GridBoundComponent
	var goal := cmp.grid_coordinate

	if goal == movement.grid_coordinate + movement.grid_direction:
		Stats.health -= attack_strength

func _on_timer_timeout():
	var cmp := Globals.get_character_controller().get_component(GridBoundComponent.GB_COMPONENT_NAME) as GridBoundComponent
	var goal := cmp.grid_coordinate

	var result := movement.approach(goal)
	if result == AIMovementComponent.POSITION_REACHED:
		attempt_attack()
	# elif result == AIMovementComponent.NO_PATH:
		# print("No path :(")

func on_attack():
	_health -= 15

func on_player_is_close():
	player_is_close.emit()

func on_player_is_far():
	player_is_far.emit()

func _on_grid_movement_component_movement_started():
	entity.start_walking_anim()

func _on_grid_movement_component_movement_finished():
	entity.finish_walking_anim()

func _on_grid_movement_component_rotation_started():
	entity.start_walking_anim()

func _on_grid_movement_component_rotation_finished():
	entity.finish_walking_anim()
