extends Node3D

@onready var anim = $AnimatedSprite3D
@onready var anim2 = $AnimatedSprite3D2
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("fire_anim")
	anim.play("fire_anim")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
