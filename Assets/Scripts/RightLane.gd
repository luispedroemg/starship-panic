extends Position3D

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
	
	#X axis : center of the screen
	self.translation.z = (30 * self.window_x)/self.originalWindowSizeX