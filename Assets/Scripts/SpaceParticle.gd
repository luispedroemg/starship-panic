extends MeshInstance
signal dead_particle

export (PackedScene) var Explosion
export (PackedScene) var Drop
export (float) var speed = 75
export (float) var drop_chance = 0.45
var explosion

func _ready():
	var asteroid_num = (randi() % 3) + 2
	var mesh = load('res://Assets/Models/asteroid' + str(asteroid_num) + '.obj')
	self.set_mesh(mesh)
	self.rotate_x(randf() * 2 * PI)
	self.rotate_y(randf() * 2 * PI)
	self.rotate_z(randf() * 2 * PI)

func start(manager):
	self.connect("dead_particle", manager, "on_dead_particle", [self])

func _process(delta):
	self.global_translate(Vector3(-self.speed * delta, 0, 0))

func _on_CollisionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	print(area.get_name())
	self._explode()
	self._drop()
	self.emit_signal("dead_particle");

func _explode():
	var explosion = Explosion.instance()
	self.get_tree().get_root().get_node("Root/Main").add_child(explosion)
	explosion.global_transform.origin = self.global_transform.origin
	explosion.emitting=true

func _drop():
	if(randf() < self.drop_chance):
		var drop = self.Drop.instance()
		self.get_tree().get_root().get_node("Root/Main").add_child(drop)
		var position = self.global_transform.origin
		var pos_delta = position - drop.global_transform.origin
		drop.global_translate(pos_delta)
		drop.speed = self.speed

func _on_VisibilityNotifier_screen_exited():
	self.emit_signal("dead_particle");
