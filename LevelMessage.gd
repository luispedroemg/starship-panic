extends Label

func show_level(level):
	self.text = "%d" % level
	self.visible = true
	$LevelMTimer.start()


func _on_LevelMTimer_timeout():
	self.visible = false
