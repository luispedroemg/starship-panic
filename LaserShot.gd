extends Spatial

export (float) var speed=600

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	self.global_translate(Vector3(self.speed*delta,0,0))


func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	self.queue_free()
