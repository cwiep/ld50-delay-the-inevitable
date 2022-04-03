extends Node2D

func _ready():
	$Score.text = "%s people were saved" % Global.saved
