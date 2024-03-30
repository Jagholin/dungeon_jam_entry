class_name RawEnemyBlack
extends Node3D

signal attack_animation_hit
@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("EnemyArmature|EnemyArmature|Idle")

func start_walking_anim():
	anim_player.play("EnemyArmature|EnemyArmature|Run")

func finish_walking_anim():
	anim_player.play("EnemyArmature|EnemyArmature|Idle")

func start_attack_anim():
	anim_player.play("EnemyArmature|EnemyArmature|Attack")
	var tween := create_tween()
	tween.tween_interval(0.5)
	tween.tween_callback(func():
		attack_animation_hit.emit())

func start_death_anim():
	anim_player.play("EnemyArmature|EnemyArmature|Death")

func start_hit_anim():
	anim_player.play("EnemyArmature|EnemyArmature|HitRecieve")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "EnemyArmature|EnemyArmature|Attack":
		anim_player.play("EnemyArmature|EnemyArmature|Idle")
