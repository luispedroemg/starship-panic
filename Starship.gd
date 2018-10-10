extends Spatial

export (PackedScene) var LaserShot
export (float) var speed = 1.0 # seconds to move to lane
var can_shoot = true
var lanes
var current_lane = 1
var target_lane = 1
var lane_timer = 0.0

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		if(self.can_shoot):
			var shot = LaserShot.instance()
			shot.global_transform = self.global_transform
			self.get_parent().add_child(shot)
			$ShotTimer.start();
			self.can_shoot = false
	
	if(self.current_lane == self.target_lane): # can only switch while not in between
		if Input.is_action_just_pressed("ui_left") && self.target_lane > 0:
			self.target_lane -= 1
		if Input.is_action_just_pressed("ui_right") && self.target_lane < self.lanes.size() - 1:
			self.target_lane += 1
	else:
		self._move(delta)

func _move(delta):
	self.lane_timer += delta
	var completed_fraction = self.lane_timer / self.speed
	if(completed_fraction < 1.0):
		var distance_vec = self.lanes[self.target_lane].transform.origin - self.lanes[self.current_lane].transform.origin 
		self.transform.origin = self.lanes[self.current_lane].transform.origin + (distance_vec * completed_fraction)
	else:
		self.transform.origin = self.lanes[self.target_lane].transform.origin
		self.lane_timer = 0.0
		self.current_lane = self.target_lane

func _on_ShotTimer_timeout():
	self.can_shoot = true
	
func start(lanes):
	self.lanes = lanes;

func _on_CollisionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	print("You died!")
	print("Collided with: "+area.get_parent().get_parent().name)
	self.hide()
	self.queue_free()
	pass
