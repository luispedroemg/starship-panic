extends Spatial

export (PackedScene) var SpaceParticle
export (int) var num_particles=25
var generated = false

func _ready():
	pass

func _process(delta):
	if(!self.generated):
		for i in range(self.num_particles):
			self._generate_particle()
		self.generated = true

func _generate_particle():
	var space_particle = SpaceParticle.instance()
	self.get_parent().add_child(space_particle)
	space_particle.global_transform.origin = Vector3(1000 - randf()*700, 2, (randf() * 100) - 50)
	space_particle.get_child(0).connect("dead_particle", self, "on_dead_particle")
	
func on_dead_particle():
	self._generate_particle()