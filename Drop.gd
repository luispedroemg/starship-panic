extends Spatial
signal got_drop

export (float) var speed = 75
export (PackedScene) var ShieldDrop
export (PackedScene) var EnergyDrop

var drop_list = ["energy_drop", "shield_drop"]
var selected
var mesh
var life_time = 0
var emission_step = 0
var emission_increase = true

func _ready():
	self.selected = drop_list[randi()%self.drop_list.size()]
	self.mesh = null
	match(self.selected):
		"energy_drop":
			self.mesh = EnergyDrop.instance()
		"shield_drop":
			self.mesh = ShieldDrop.instance()
	self.add_child(self.mesh)
	$DropCollision.name=self.selected
	$DropSound.stream.loop_mode = AudioStreamSample.LOOP_PING_PONG # not working... =\
	# 0 <= emission_energy <= 16
	self.mesh.get_surface_material(3).emission_energy = self.emission_step

func _process(delta):
	# HUGE THOR!!!!!!!
	if(self.global_transform.origin.length() > 1):
		self.get_node(self.selected).monitoring = true
		self.get_node(self.selected).monitorable = true
	# !!!!!!!!!!!!!!!!
	self.global_translate(Vector3(-self.speed * delta, 0, 0))
	self.life_time += delta
	self._emission(delta)

func _emission(delta):
	if(self.emission_increase):
		self.emission_step += delta * 40
		if(self.emission_step > 16):
			self.emission_increase = false
	else:
		self.emission_step -= delta * 30
		if(self.emission_step < 0):
			self.emission_increase = true
	self.mesh.get_surface_material(3).emission_energy = self.emission_step

func _on_DropCollision_area_shape_entered(area_id, area, area_shape, self_shape):
	print("drop collision with: "+area.get_name())
	self.global_translate(Vector3(10000, 10000, 1000)) # move it out of the way =P
	queue_free()

func _on_VisibilityNotifier_screen_exited():
	queue_free()
