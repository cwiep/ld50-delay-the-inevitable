extends Button

func set_card(card: Card) -> void:
	var result = card.get_name() + "\n=====\n\n"
	for action in card.get_actions():
		result += "%s %s\n" % [Global.labels[action[0]], action[1]]
	$Label.text = result
