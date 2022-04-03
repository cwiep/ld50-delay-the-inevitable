extends Control

var _clicked: bool = false

func _process(delta):
	if Input.is_action_just_pressed("choose_left") or Input.is_action_just_pressed("choose_right"):
		_on_Start_pressed()

func _on_Start_pressed():
	if _clicked:
		var _result = get_tree().change_scene("res://scenes/Main.tscn")
	else:
		$Label.text = "... but they were out partying and getting drunk.\n\nAnd so it was all on you..."
		$Start.text = "I said start!"
		_clicked = true
