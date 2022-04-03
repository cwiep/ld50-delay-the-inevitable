extends Control

var _clicked: bool = false
		
func _input(event):
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		_on_Start_pressed()

func _on_Start_pressed():
	$ButtonClickSound.play()
	if _clicked:
		var _result = get_tree().change_scene("res://scenes/Main.tscn")
	else:
		$Label.text = "... but they were out partying and getting drunk.\n\nAnd so it was all on you..."
		$Start.text = "I said start!"
		$Controls.show()
		$ControlsIcon.show()
		$Explanation.show()
		_clicked = true
