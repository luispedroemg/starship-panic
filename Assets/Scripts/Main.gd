extends Spatial
signal game_over

var speedup_amount = 25
var lanes
var current_lane
var time = 0.0
var level = 0

func _ready():
	randomize()
	print("Main scene ready!")
	self.lanes = [$LeftLane, $CenterLane, $RightLane]
	self.current_lane = 1
	self._begin()

func _process(delta):
	self.time += delta
	$UI/EnergyBar.value = $Starship.energy
	$UI/ShieldBar.value = $Starship.shield
	$UI/Timer.text = "%.2f" % self.time

func _begin():
	$Starship.start(self.lanes, $Entrance)
	$SpaceParticles.start(self.lanes)

func _on_Starship_player_dead():
	$UI/DeathTimer.start()
	$UI/Message.text += "%.0f" % self.time
	$UI/Message.text += "\n Enter your name:"
	$UI/Message.show()

func _on_SpeedTimer_timeout():
	print("SPEED INCREASE")
	$SpaceParticles.increase_speed(self.speedup_amount)
	self.level += 1
	$UI/LevelMessage.show_level(self.level)
	
func _on_DeathTimer_timeout():
	emit_signal("game_over")
