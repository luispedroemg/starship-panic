extends Spatial

var MainScene
var MenuBG
var ScoreBoard
var menu_bg
var instancedScene
var instancedSceneRunning = false
var transition = false
var scores = Array()

func _ready():
	self.MainScene = load("res://Main.tscn")
	self.MenuBG = load("res://MenuBG.tscn")
	self.ScoreBoard = load("res://ScoreBoard.tscn")
	self.menu_bg = self.MenuBG.instance()
	self.add_child(self.menu_bg)

func _process(delta):
	if(self.transition):
		self._process_transition(delta)

func _process_transition(delta):
	var color = $Menu/TransitionPanel.get_stylebox("panel").get_bg_color()
	var alpha_delta = color.a + delta
	color = Color(0, 0, 0, alpha_delta)
	$Menu/TransitionPanel.get_stylebox("panel").set_bg_color(color)
	$Menu/TransitionPanel.update()
	if(alpha_delta > 1.2):
		self._load_scene(self.MainScene, "game_over", "on_game_over")
		$Menu/TransitionPanel.visible = false
		self.transition = false

func _on_StartButton_pressed():
	if(!self.instancedSceneRunning):
		self._start_transition()
		

func _start_transition():
	$Menu/TransitionPanel.visible = true
	var color = Color(0, 0, 0, 0)
	$Menu/TransitionPanel.get_stylebox("panel").set_bg_color(color)
	self.transition = true

func _load_scene(sceneResource, signal_name, signal_function):
	$Music.stop()
	self.instancedScene = sceneResource.instance();
	self.add_child(self.instancedScene)
	self.instancedSceneRunning = true
	self.instancedScene.connect(signal_name, self, signal_function)
	self.menu_bg.hide()
	$Menu.hide()
	self.menu_bg.queue_free()

func on_game_over(player_name, score):
	self.scores.append([player_name, score])
	self.instancedScene.hide()
	self.instancedScene.queue_free();
	self.instancedSceneRunning = false;
	self.instancedScene = null
	self.menu_bg=self.MenuBG.instance()
	self.add_child(self.menu_bg)
	$Menu.show()
	self.menu_bg.show()
	$Music.play()

func on_ScorePanel_return():
	print("Closed score panel signal")
	self.instancedScene.hide()
	self.instancedScene.queue_free();
	self.instancedSceneRunning = false;
	self.instancedScene = null
	self.menu_bg=self.MenuBG.instance()
	self.add_child(self.menu_bg)
	$Menu.show()
	self.menu_bg.show()
	$Music.play()

func _on_ScoresButton_pressed():
	_load_scene(self.ScoreBoard, "score_return", "on_ScorePanel_return")
	self.instancedScene.setScores(self.scores)