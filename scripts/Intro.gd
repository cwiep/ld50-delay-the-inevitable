extends Control

func _process(delta):
	if Input.is_action_just_pressed("choose_left") or Input.is_action_just_pressed("choose_right"):
		_on_Start_pressed()

func _on_Start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
