extends Node3D

@onready var anim = $AnimatedSprite3D
@onready var anim2 = $AnimatedSprite3D2
@onready var audio = $AudioStreamPlayer3D
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("fire_anim")

func _on_audio_stream_player_3d_finished():
	audio.play()
