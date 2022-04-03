extends Button

func set_card(card: Card) -> void:
	var result = card.get_name() + "\n=====\n\n"
	for action in card.get_actions():
		result += "%s %s\n" % [Global.labels[action[0]], action[1]]
		
	if card.get_cost() > 0:
		result += "\n\nPay %s %s:\n" % [card.get_cost(), Global.cost_labels[card.get_cost_type()]]
		for action in card.get_paid_actions():
			result += "%s %s\n" % [Global.labels[action[0]], action[1]]
		
	$Label.text = result
