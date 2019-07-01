extends Button

# class member variables go here, for example:
var window_x = 1
var window_y = 1

#func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#do nothing

func _process(delta):
	#get the size of the screen X and Y 
	self.window_x = OS.get_real_window_size().x
	#print("Window_x: ", self.window_x)
	self.window_y = OS.get_real_window_size().y
	#print("Window_y: ", self.window_y)
	var label_sizex = self.get_rect().size.x
	var label_sizey = self.get_rect().size.y
	#print("label_size_x: ", label_sizex)
	#X axis : center of the screen
	self.rect_position.x = (self.window_x*0.5) - label_sizex*0.5
	#Y Axis : 50% of the screen
	self.rect_position.y = (self.window_y*0.6) - label_sizey*0.7
	#print("final calc: ", self.rect_position.x)