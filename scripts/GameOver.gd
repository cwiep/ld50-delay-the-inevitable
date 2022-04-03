extends Node2D

func _ready():
	$Score.text = "%s people were saved" % Global.saved

func _input(event):
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		get_tree().change_scene("res://scenes/Intro.tscn")
