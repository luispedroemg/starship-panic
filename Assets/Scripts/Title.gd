extends Label

# class member variables go here, for example:
var window_x = 1
var window_y = 1
var originalWindowSizeX = 1040
#func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#do nothing

func _process(delta):
	#get the size of the screen X and Y 
	self.window_x = OS.get_real_window_size().x
	self.window_y = OS.get_real_window_size().y
	
	var label_sizex = self.get_rect().size.x
	var label_sizey = self.get_rect().size.y
	#print("label_size_x: ", label_sizex)
	self.rect_size.x = (label_sizey * self.window_x)/self.originalWindowSizeX
	#print(self.get_rect().size.x)
	#X axis : center of the screen
	self.rect_position.x = (self.window_x*0.5) - label_sizex*0.5
	#Y Axis : 80% of the screen
	self.rect_position.y = (self.window_y*0.10) - label_sizey*0.5
	#print("final calc: ", self.rect_position.x)
	#var fontSize = self.get("custom_fonts/font").get_size()
	self.get("custom_fonts/font").set_size((100 * self.window_x)/self.originalWindowSizeX)
	
	