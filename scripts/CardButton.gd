extends Button

export (String) var button_text = ""

func _ready():
	$Label.text = button_text
