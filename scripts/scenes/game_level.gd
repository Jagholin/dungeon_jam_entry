class_name Level
extends Node3D

signal game_over()

@export var grid_map: GridMap
var mesh_library: MeshLibrary
@onready var hp_bar: ProgressBar = %HPBar
@onready var notification_label: Label = %NotificationLabel
@onready var attack_indicator: TextureRect = %AttackIndicator

var notify_tween: Tween = null
var attack_tween: Tween = null

func _input(event):
	if event.is_action_pressed("attack"):
		show_attack_indicator()
		attempt_attack()

func _ready():
	Stats.health_changed.connect(on_health_changed)
	Stats.reset_stats()
	on_health_changed()
	mesh_library = grid_map.mesh_library
	call_deferred(&"after_ready")

func after_ready():
	Grids.initialize()
	PlayerTrackers.initialize()
	NotableObjects.initialize()
	
	# get_tree().call_group("after_ready", "after_ready")

func location_exists(c: Vector3i) -> bool:
	return grid_map.get_cell_item(c) != -1

## returns true if the tile at (x, y) is a wall
## tests the name of the tile and if it has "wall" in it returns true
func is_a_wall(c: Vector3i) -> bool:
	var item := grid_map.get_cell_item(c)
	assert(item != -1, "Item has to exist")
	return mesh_library.get_item_name(item).contains("wall")
	
func map_global_to_gridcoord(c: Vector3) -> Vector3i:
	var localGridTestPoint := grid_map.to_local(c)
	return grid_map.local_to_map(localGridTestPoint)


func _on_buttons_pressed(_value):
	pass
	#print("You pressed the button with value, ", value)


func _on_simon_says_success():
	#pass
	print("You won the minigame! congrats")

func on_health_changed():
	if Stats.health <= 0:
		print("Game Over")
		game_over.emit()
		return
	hp_bar.value = Stats.health
	hp_bar.max_value = Stats.max_health

func show_note(note: String):
	if notify_tween:
		notify_tween.kill()
	notification_label.text = note
	notify_tween = create_tween()
	notify_tween.tween_interval(1.5)
	notify_tween.tween_callback(func():
		notification_label.text = ""
		notify_tween = null)

func show_attack_indicator():
	if attack_tween:
		attack_tween.kill()
	attack_indicator.show()
	attack_tween = create_tween()
	attack_tween.tween_interval(0.23)
	attack_tween.tween_callback(func():
		attack_indicator.hide()
		attack_tween = null)

func attempt_attack():
	var character := Globals.get_character_controller()
	var chr_pos := character.get_component(GridDirectionalComponent.GD_COMPONENT_NAME) as GridDirectionalComponent
	var target := chr_pos.grid_coordinate + chr_pos.grid_direction

	var target_obj := NotableObjects.get_object(target)
	if target_obj and target_obj is Enemy:
		target_obj.on_attack()
	else:
		show_note("No enemy to attack")

func _on_player_trigger_info_enemy_player_entered():
	show_note("Enemy encounter")


func _on_player_trigger_info_ss_player_entered():
	show_note("Simon says mini-game")


func _on_player_trigger_info_levers_player_entered():
	show_note("Traps and levers")
