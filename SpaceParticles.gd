extends Spatial

export (PackedScene) var SpaceParticle
export (int) var num_particles=25
var generated = false
var lanes = null

func _ready():
	pass

func _process(delta):
	if(!self.generated && self.lanes != null):
		for i in range(self.num_particles):
			self._generate_particle()
		self.generated = true

func _generate_particle():
	var chosen_lane_idx = randi() % self.lanes.size()
	var z = self.lanes[chosen_lane_idx].global_transform.origin.z
	var space_particle = SpaceParticle.instance()
	space_particle.get_node("MeshInstance/CollisionArea").set_collision_layer_bit(1, false);
	space_particle.get_node("MeshInstance/CollisionArea").set_collision_mask_bit(0, false);
	space_particle.get_node("MeshInstance/CollisionArea").set_collision_mask_bit(2, false);
	self.add_child(space_particle)
	space_particle.global_transform.origin = Vector3(1000 - randf()*700, 2, z)
	space_particle.get_child(0).connect("dead_particle", self, "on_dead_particle")
	space_particle.get_node("MeshInstance/CollisionArea").set_collision_layer_bit(1, true);
	space_particle.get_node("MeshInstance/CollisionArea").set_collision_mask_bit(0, true);
	space_particle.get_node("MeshInstance/CollisionArea").set_collision_mask_bit(2, true);

func start(lanes):
	self.lanes = lanes

func on_dead_particle():
	self._generate_particle()