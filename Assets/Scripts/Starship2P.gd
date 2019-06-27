extends Spatial
signal player_dead

export (PackedScene) var LaserShot
export (PackedScene) var ExplosionShip
export (float) var speed = 1.0 # seconds to move to lane
export (float) var max_energy = 100.0
export (float) var max_shield = 100.0
export (float) var energy_per_shot = 25.0
export (float) var energy_rate = 2.0
export (float) var shield_rate = 3.0
export (float) var shield_passive = 0.5
export (float) var alarm_threshold = 30.0
var energy = 100.0
var can_shoot = true
var shield_active = false
var shield = 100.0
var lanes
var last_lane = 1
var current_lane = 1
var target_lane = 1
var lane_timer = 0.0
var active = false
var playing_sound = null
var alarm = false

func start(lanes, entrance):
	self.lanes = lanes
	self.global_transform.origin = entrance.global_transform.origin
	self._play_sound($HyperDrive)
	
func _ready():
	print(self.lanes)

func _process(delta):
	if(active):
		if Input.is_action_pressed("ui_page_up"):
			self._shoot()
		
		if Input.is_action_just_pressed("ui_page_down"):
			self._toggle_shield()
		
		if(self.current_lane == self.target_lane): # can only switch while not in between
			if(self.last_lane < self.current_lane):
				self.rotate_x(-0.2)
				self.last_lane = self.current_lane #just enters the if only once
			if(self.last_lane > self.current_lane):
				self.rotate_x(0.2)
				self.last_lane = self.current_lane #just enters the if only once
			if Input.is_key_pressed(KEY_KP_4) && self.target_lane > 0:
				self.last_lane = self.current_lane
				self.target_lane -= 1
				self.rotate_x(-0.2)
			if Input.is_key_pressed(KEY_KP_6) && self.target_lane < self.lanes.size() - 1:
				self.last_lane = self.current_lane
				self.target_lane += 1
				self.rotate_x(0.2)
		else:
			self._move(delta)
			
			
		
		self._update_energy(delta)
		self._process_alarm()
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
			self._play_sound($WeaponOff)

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
				_play_sound_for_shield(self.shield - 25)
				
		_:
			if(self.shield_active):
				self.shield -= 20
				self._play_sound_for_shield(self.shield + 20)
			else:
				self._player_dead()

func _player_dead(explode=false):
	print("You died!")
	if(explode):
		var explosion = ExplosionShip.instance()
		self.get_tree().get_root().get_node("Root/Main").add_child(explosion)
		explosion.global_transform.origin = self.global_transform.origin
	$Alarm.stop()
	self.hide()
	self.global_translate(Vector3(20000, 20000, 2000))
	self.active = false
	self.emit_signal("player2_dead")

func _play_sound_for_shield(prev_shield):
	#play a sound when shield is at X percent
	if(prev_shield < 100 && self.shield >=100):
		_play_sound($ForceField100)
	elif(prev_shield >= 75 && self.shield <= 75):
		_play_sound($ForceField75)
	elif(prev_shield > 50 && self.shield <= 50):
		_play_sound($ForceField50)
	elif(prev_shield > 25 && self.shield <= 25):
		_play_sound($ForceField25)
	elif(prev_shield > 15 && self.shield <= 15):
		_play_sound($ForceFieldFailure)
	
func _play_sound(sound):
	if(self.playing_sound != null):
		self.playing_sound.stop()
	self.playing_sound = sound
	sound.play(0)
	
func _update_energy(delta):
	var prev_shield = self.shield
	#Passive shield loss
	self.shield -= delta * self.shield_passive
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
	self._play_sound_for_shield(prev_shield)
	if(self.shield == 0):
		self._player_dead(true)

func _process_alarm():
	if(!self.alarm && self.shield < self.alarm_threshold):
		self.alarm = true
		$Alarm.play()
	elif(self.alarm && self.shield > self.alarm_threshold):
		self.alarm = false
		$Alarm.stop()

func _toggle_shield():
	self.shield_active = !self.shield_active
	$MeshInstance/ShieldMesh.visible = self.shield_active
