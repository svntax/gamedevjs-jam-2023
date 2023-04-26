extends Node2D

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

onready var move = false
onready var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	if rand_range(0, 1) < 0.06:
		animation_player.play("idle", -1, rand_range(0.2, 0.6))
	if rand_range(0, 1) < 0.2:
		sprite.frame = 1
	else:
		sprite.frame = 0

func _process(delta):
	if move:
		if sprite.frame == 1:
			global_position.x -= speed + 2
		else:
			global_position.x -= speed
		if global_position.x < 0:
			global_position.x = 660
			global_position.y = rand_range(0, 360)

func set_moving(flag: bool) -> void:
	move = flag
