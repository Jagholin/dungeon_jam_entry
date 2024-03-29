class_name FirstLevel
extends Level

# Starting time remaining in seconds
@export var start_time: int = 60 * 3
@export var spikes_a: Array[Spikes]
@export var spikes_b: Array[Spikes]
@export var spikes_c: Array[Spikes]

@onready var solution_components: Label = %SolutionComponents

@onready var enemy_bar: ProgressBar = %EnemyHPBar
@onready var enemy_title: Label = %EnemyTitle
@onready var time_bar: ProgressBar = %TimeBar
@onready var time_label: Label = %TimeRemaining

@onready var gate_console: GateConsole = %gate_console

var seconds_passed: float = 0.0
var previous_phase: int = 0
var time_left: int = start_time:
	set(value):
		if value == time_left:
			return
		time_left = value
		time_bar.value = time_left
		var minutes: int = floori(time_left / 60.0)
		var seconds: int = time_left % 60
		time_label.text = "%02d:%02d" % [minutes, seconds]
		if time_left <= 0:
			game_over.emit("Time ran out!")

var red_decoded: bool
var green_decoded: bool
var blue_decoded: bool

var enemy: Enemy

func _ready():
	super._ready()
	enemy_bar.hide()
	enemy_title.hide()
	time_bar.max_value = start_time

	NotableObjects.on_new_object_registered.connect(_on_enemy_moved_or_spawned)

func _process(delta):
	#super._process(delta)
	seconds_passed += delta

	time_left = start_time - floori(seconds_passed)
	
	var phase: int = floori(seconds_passed) % 3
	if phase != previous_phase:
		for s in spikes_a:
			if phase == 0:
				s.apply_active()
			else:
				s.apply_hidden()
		for s in spikes_b:
			if phase == 1:
				s.apply_active()
			else:
				s.apply_hidden()
		for s in spikes_c:
			if phase == 2:
				s.apply_active()
			else:
				s.apply_hidden()
	previous_phase = phase

func _on_red_entered_trigger_player_entered():
	show_note("[ZONE: RED]")

func _on_green_entered_trigger_player_entered():
	show_note("[ZONE: GREEN]")

func _on_blue_entered_trigger_player_entered():
	show_note("[ZONE: BLUE]")

func _on_lever_green_solved_switched_on():
	show_note("Green component: 122379")
	if green_decoded:
		return
	start_time += 60
	time_bar.max_value = start_time
	Stats.health += 20
	solution_components.text += "GREEN: 122379\n"
	green_decoded = true

func _on_enemy_defeated():
	show_note("Blue component: 322764")
	if blue_decoded:
		return
	start_time += 60
	time_bar.max_value = start_time
	Stats.health += 20
	solution_components.text += "BLUE: 322764\n"
	blue_decoded = true
	
func _on_simon_says_success():
	if red_decoded:
		return
	start_time += 60
	time_bar.max_value = start_time
	Stats.health += 20
	solution_components.text += "RED: 358980\n"
	red_decoded = true

func _on_enemy_moved_or_spawned(obj: Object, _coord: Vector3i):
	if obj is Enemy:
		if enemy == obj:
			return
		enemy = obj
		enemy.player_is_close.connect(_on_player_close_to_enemy)
		enemy.player_is_far.connect(_on_player_far_from_enemy)
		enemy.health_changed.connect(_on_enemy_health_changed)
		enemy.defeated.connect(_on_player_far_from_enemy)

func _on_player_close_to_enemy():
	enemy_bar.show()
	enemy_title.show()
	enemy_bar.value = enemy._health

func _on_player_far_from_enemy():
	enemy_bar.hide()
	enemy_title.hide()

func _on_enemy_health_changed():
	enemy_bar.value = enemy._health

func _on_trigger_win_condition_player_entered():
	if gate_console.is_active:
		var score := 0
		if red_decoded:
			score += 100
		if green_decoded:
			score += 100
		if blue_decoded:
			score += 100
		# +1 score for each second remaining
		score += time_left
		game_won.emit(score)
