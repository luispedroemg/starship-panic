extends Spatial
signal game_over(player_name, score)

var speedup_amount = 25
var lanesP1
var lanesP2
var current_laneP1
var current_laneP2
var time = 0.0
var level = 0
var score

func _ready():
	randomize()
	print("Main scene ready!")
	self.lanesP1 = [$LeftLane1P, $CenterLane1P, $RightLane1P]
	self.lanesP2 = [$LeftLane2P, $CenterLane2P, $RightLane2P]
	self.current_laneP1 = 1
	self.current_laneP2 = 1
	self._begin()

func _process(delta):
	self.time += delta
	$UI/EnergyBarP1.value = $StarshipP1.energy
	$UI/ShieldBarP1.value = $StarshipP1.shield
	$UI/EnergyBarP2.value = $StarshipP2.energy
	$UI/ShieldBarP2.value = $StarshipP2.shield
	$UI/Timer.text = "%.2f" % self.time

func _begin():
	$StarshipP1.start(self.lanesP1, $Entrance)
	$StarshipP2.start(self.lanesP2, $Entrance)
	$SpaceParticles.start(self.lanesP1 + self.lanesP2)

func _on_Starship_player_dead():
	$StarshipP2.global_translate(Vector3(20000, 20000, 2000))
	self.score = "%.0f" % self.time
	$UI/Message.text = "Player 2 is the winner after " + self.score + "secs"
	$UI/Message.show()
	$UI/ExitSubmit.show()
	
func _on_StarshipP2_player_dead():
	$StarshipP1.global_translate(Vector3(20000, 20000, 2000))
	self.score = "%.0f" % self.time
	$UI/Message.text = "Player 1 is the winner after " + self.score + "secs"
	$UI/Message.show()
	$UI/ExitSubmit.show()

func _on_SpeedTimer_timeout():
	print("SPEED INCREASE")
	$SpaceParticles.increase_speed(self.speedup_amount)
	self.level += 1
	$UI/LevelMessage.show_level(self.level)
	
func _on_GameOver():
	emit_signal("game_over", null, 0)

func _on_NameSubmit_pressed():
	_on_GameOver()



