extends MeshInstance

export (float) var rotation_speed = 5

func _process(delta):
	self.transform = self.transform.rotated(Vector3(0,1,0), rotation_speed * delta)
