extends Panel

func _ready():
	addScore("Luis", 1000)
	addScore("Correia", 1)
	return

func addScore(playerName, score):
	$ItemList.add_item(playerName);
	$ItemList.add_item(str(score));
	return