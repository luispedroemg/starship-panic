extends Spatial

export (PackedScene) var SpaceParticle
export (int) var num_particles=45
export (float) var particle_speed=75
var generated = false
var lanes = null
var particles = Array()

func _ready():
	pass

func _process(delta):
	if(!self.generated && self.lanes != null):
		for i in range(self.num_particles):
			particles.append(self._generate_particle())
		self.generated = true

func _generate_particle():
	var chosen_lane_idx = randi() % self.lanes.size()
	var z = self.lanes[chosen_lane_idx].global_transform.origin.z
	var space_particle = SpaceParticle.instance()
	self.add_child(space_particle)
	space_particle.global_transform.origin = Vector3(1000 - randf()*700, 2, z)
	space_particle.get_child(0).start(self)
	space_particle.get_child(0).speed = self.particle_speed
	return space_particle
	
func _reset_particle(space_particle):
	var chosen_lane_idx = randi() % self.lanes.size()
	var z = self.lanes[chosen_lane_idx].global_transform.origin.z
	var position = Vector3(1000, 2, z)
	var pos_delta = position - space_particle.global_transform.origin
	space_particle.global_translate(pos_delta)
	space_particle.show()

func start(lanes):
	self.lanes = lanes
	
func increase_speed(amount):
	self.particle_speed += amount
	for space_particle in particles:
		space_particle.get_child(0).speed = self.particle_speed

func on_dead_particle(space_particle):
	self._reset_particle(space_particle)