extends Spatial
signal got_drop

export (float) var speed = 75
export (PackedScene) var ShieldDrop
export (PackedScene) var EnergyDrop

var drop_list = ["energy_drop", "shield_drop"]
var selected

func _ready():
	self.selected = drop_list[randi()%self.drop_list.size()]
	var instance = null
	match(self.selected):
		"energy_drop":
			instance = EnergyDrop.instance()
		"shield_drop":
			instance = ShieldDrop.instance()
	self.add_child(instance)
	$DropCollision.name=self.selected
	$DropSound.stream.loop_mode = AudioStreamSample.LOOP_PING_PONG # not working... =\

func _process(delta):
	if(self.global_transform.origin.length() > 1):
		self.get_node(self.selected).monitoring = true
		self.get_node(self.selected).monitorable = true
	self.global_translate(Vector3(-self.speed * delta, 0, 0))


func _on_DropCollision_area_shape_entered(area_id, area, area_shape, self_shape):
	print("drop collision with: "+area.get_name())
	self.global_translate(Vector3(10000, 10000, 1000)) # move it out of the way
	queue_free()

func _on_VisibilityNotifier_screen_exited():
	queue_free()
