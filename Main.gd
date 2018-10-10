extends Spatial

var lanes
var current_lane

func _ready():
	self.lanes = [$LeftLane, $CenterLane, $RightLane]
	self.current_lane = 1
	$Starship.start(self.lanes)