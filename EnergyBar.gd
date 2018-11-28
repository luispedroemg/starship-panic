extends ProgressBar

var num_lines = 4

func _draw():
	var step = self.rect_size.x / num_lines
	for i in range (self.num_lines - 1):
		self.draw_line(Vector2(step * (i+1), 0), Vector2(step * (i+1), self.rect_size.y), Color(0,0,0))
