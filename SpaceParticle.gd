extends MeshInstance
signal dead_particle

export (float) var speed = 75

func _ready():
	var asteroid_num = (randi() % 3) + 2
	var mesh = load('res://Assets/Models/asteroid' + str(asteroid_num) + '.obj')
	self.set_mesh(mesh)
	self.rotate_x(randf() * 2 * PI)
	self.rotate_y(randf() * 2 * PI)
	self.rotate_z(randf() * 2 * PI)

func _process(delta):
	self.global_translate(Vector3(-self.speed * delta, 0, 0))

func _on_VisibilityNotifier_screen_exited():
	self.emit_signal("dead_particle");
	self.get_parent().queue_free();

func _on_CollisionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	$CollisionArea/CollisionShape.queue_free();
	self.get_parent().queue_free();
