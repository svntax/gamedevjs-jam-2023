extends ColorRect

func _draw():
	for i in range(1000):
		var x = rand_range(0, 640)
		var y = rand_range(0, 360)
		var size = int(rand_range(0, 2))
		draw_rect(Rect2(x, y, size, size), Color.white)
