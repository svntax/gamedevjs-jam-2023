extends Sprite

onready var fire_left = $FireLeft
onready var fire_right = $FireRight

func set_active(flag: bool) -> void:
	fire_left.emitting = flag
	fire_right.emitting = flag
