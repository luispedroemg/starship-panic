extends ProgressBar

var num_shots = 4

func set_shots(num_shots):
	self.num_shots = num_shots

func _draw():
	var step = self.rect_size.x / num_shots
	for i in range (self.num_shots - 1):
		self.draw_line(Vector2(step * (i+1), 0), Vector2(step * (i+1), self.rect_size.y), Color(0,0,0))
