extends Control
signal score_return

class ScoreSorter:
	static func sort(a,b):
		if int(a[1]) > int(b[1]):
			return true
		return false

func addScore(playerName, score):
	$ScorePanel/ItemList.add_item(playerName);
	$ScorePanel/ItemList.add_item(str(score));

func setScores(scores):
	var sorted = scores.duplicate()
	sorted.sort_custom(ScoreSorter, "sort")
	for score in sorted:
		addScore(score[0], score[1])

func _on_BackButton_pressed():
	print("Main Menu button pressed!")
	emit_signal("score_return")
