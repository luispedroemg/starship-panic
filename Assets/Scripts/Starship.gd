extends Spatial
signal player_dead

export (PackedScene) var LaserShot
export (float) var speed = 1.0 # seconds to move to lane
export (float) var max_energy = 100.0
export (float) var max_shield = 100.0
export (float) var energy_per_shot = 25.0
export (float) var energy_rate = 2
export (float) var shield_rate = 5
var energy = 100.0
var can_shoot = true
var lanes
var last_lane = 1
var current_lane = 1
var target_lane = 1
var lane_timer = 0.0
var shield_active = false
var shield = 100.0
var active = false

func start(lanes, entrance):
	self.lanes = lanes
	self.global_transform.origin = entrance.global_transform.origin
	self._play_sound("hyper drive activated")
	
func _ready():
	print(self.lanes)

func _process(delta):
	if(active):
		if Input.is_action_pressed("ui_accept"):
			self._shoot()
		
		if Input.is_action_just_pressed("ui_focus_next"):
			self._toggle_shield()
		
		if(self.current_lane == self.target_lane): # can only switch while not in between
			if(self.last_lane < self.current_lane):
				self.rotate_x(-0.2)
				self.last_lane = self.current_lane #just enters the if only once
			if(self.last_lane > self.current_lane):
				self.rotate_x(0.2)
				self.last_lane = self.current_lane #just enters the if only once
			if Input.is_action_just_pressed("ui_left") && self.target_lane > 0:
				self.last_lane = self.current_lane
				self.target_lane -= 1
				self.rotate_x(-0.2)
			if Input.is_action_just_pressed("ui_right") && self.target_lane < self.lanes.size() - 1:
				self.last_lane = self.current_lane
				self.target_lane += 1
				self.rotate_x(0.2)
		else:
			self._move(delta)
			
			
		
		self._update_energy(delta)
	else:
		var pos_delta = self.lanes[self.current_lane].global_transform.origin - self.global_transform.origin
		if(pos_delta.length() > 1):
			pos_delta = pos_delta.normalized()
			self.global_translate(pos_delta * delta * 50)
		else:
			self.global_transform.origin = self.lanes[self.current_lane].global_transform.origin
			self.active = true
			#reset rotation
			

func _shoot():
	if(self.can_shoot && self.energy >= self.energy_per_shot):
		var shot = LaserShot.instance()
		shot.global_transform = self.global_transform
		self.get_parent().add_child(shot)
		self.energy -= self.energy_per_shot
		$ShotTimer.start();
		self.can_shoot = false
		$LaserSound.play()
		if(self.energy < 25): 
			self._play_sound("weapons deactivated")

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

func _on_CollisionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	print("Collided with: "+area.get_name())
	match area.get_name():
		"energy_drop":
			self.energy += 25
		"shield_drop":
			self.shield += 25
			if(self.shield >= 100):
				_play_sound_for_shield(self.shield)
				
		_:
			if(self.shield_active):
				self.shield -= 20
				self._play_sound_for_shield(self.shield)
			else:
				self._player_dead()

func _player_dead():
	print("You died!")
	self.hide()
	self.global_translate(Vector3(20000, 20000, 2000))
	self.active = false
	self.emit_signal("player_dead")

func _play_sound_for_shield(percentage):
	#play a sound when shield is at X percent
	if(percentage >= 100):
		_play_sound("force field is at full strength")	
	else: if(percentage >= 75):
		_play_sound("force field is at 75 percent strength")
	else: if(percentage >= 50):
		_play_sound("force field is at 50 percent strength")
	else: if(percentage >= 25):
		_play_sound("force field is at 25 percent strength")
	else:
		_play_sound("force field failure imminent")
	
func _play_sound(sound):
	#play sound in sound folder with <sound>.wav
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://Assets/Sound/" + sound + ".wav")
	player.play()
	
func _update_energy(delta):
	#Shield loss
	if(self.shield_active):
		self.shield -= delta * self.shield_rate
		if(self.shield < 0):
			self._toggle_shield()
	#Regen
	if(self.energy < self.max_energy):
		self.energy += delta * self.energy_rate
		
	self.energy = clamp(self.energy, 0, self.max_energy)
	self.shield = clamp(self.shield, 0, self.max_shield)

func _toggle_shield():
	self.shield_active = !self.shield_active
	$MeshInstance/ShieldMesh.visible = self.shield_active
	
	