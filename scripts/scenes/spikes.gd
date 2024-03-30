class_name Spikes
extends Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var grid_bound: GridBoundComponent = $GridBoundComponent
@onready var cooldown_timer: Timer = $CooldownTimer

@export var damage_strength: int = 10
@export var automatic_activation: bool = true

const activate_animation := "activate"
const deactivate_animation := "deactivate"

const HIDDEN_STATE := &"HIDDEN"
const ACTIVE_STATE := &"ACTIVE"
var state = "HIDDEN"

var hurting: bool = false

var time_elapsed := 0.0

var player_on_it: bool = false
var is_in_cooldown: bool = false

func set_hurting():
	hurting = true

func reset_hurting():
	hurting = false

func oops():
	if is_in_cooldown:
		return
	Stats.health -= damage_strength
	is_in_cooldown = true
	cooldown_timer.start()
	#print("oohps")

func cooldown_finished():
	is_in_cooldown = false

func on_movement_initiated():
	if hurting:
		oops()
	elif state == HIDDEN_STATE and automatic_activation:
		var t := create_tween()
		t.tween_interval(0.76)
		t.tween_callback(apply_active)
	return MovementListenerComponent.MovementEffect.NONE
		
func apply_active():
	#assert(state == HIDDEN_STATE)
	state = ACTIVE_STATE
	anim_player.play(activate_animation)

func apply_hidden():
	#assert(state == ACTIVE_STATE)
	state = HIDDEN_STATE
	anim_player.play(deactivate_animation)

func _ready():
	var charComponent := Globals.get_character_controller().get_component(&"GridDirectionalComponent") as GridDirectionalComponent
	assert(charComponent)
	charComponent.grid_coordinate_changed.connect(on_character_coordinate_changed)

func on_character_coordinate_changed(c: Vector3i):
	player_on_it = c == grid_bound.grid_coordinate

func _process(delta):
	if hurting and player_on_it:
		oops()
	if state == ACTIVE_STATE and automatic_activation:
		if player_on_it:
			time_elapsed = 0
		
		time_elapsed += delta
		if time_elapsed > 2:
			apply_hidden()
