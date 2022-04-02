extends Node2D

var deck = [
	Card.new([[Global.ACTION.MOVE_TRAIN, 5]], [[Global.ACTION.SPEED_UP_TRAIN, 1]]),
	Card.new([[Global.ACTION.SAFE, 10]], [[Global.ACTION.SAFE, 5]]),
	Card.new([[Global.ACTION.SPEED_UP_TRAIN, 1]], [[Global.ACTION.MOVE_TRAIN, 2]]),
	Card.new([[Global.ACTION.MOVE_TRAIN, 10]], [[Global.ACTION.SAFE, 2]]),
]
var trash = []
var hand = []

func _ready():
	$Progress.max_value = Global.MAX_TRAIN
	randomize()
	draw_new_cards()

func _process(_delta):
	_update_ui()

func draw_new_cards():
	# remove current hand
	while !hand.empty():
		var card = hand.pop_front()
		_apply_card(card)
		trash.append(card)
		
	print("trash size: " + str(trash.size()))
	
	print("=== drawing new cards")
	while hand.size() < 3:
		if deck.size() > 0:
			var card = deck.pop_front()
			print("drawn: " + str(card))
			hand.append(card)
		else:
			_shuffle_deck()
			
	print("deck size: " + str(deck.size()))
	_update_ui()
	
func _shuffle_deck():
	print("shuffling deck")
	while trash.size() > 0:
		deck.append(trash.pop_front())
	deck.shuffle()
	
func _update_ui():
	$Progress.value = Global.CURRENT_TRAIN
	$Cards/Label.text = "Deck: " + str(deck.size())
	$Cards/Saved.text = "Saved: " + str(Global.saved)
	$Cards/CardSlot1.text = _generate_card_text(hand[0])
	$Cards/CardSlot2.text = _generate_card_text(hand[1])

func _generate_card_text(card: Card) -> String:
	var result = ""
	for action in card.get_actions():
		result += "%s %s\n" % [Global.labels[action[0]], action[1]]
	return result

func _apply_card(card: Card) -> void:
	for action in card.get_actions():
		var action_type = action[0]
		var value = action[1]
		print("using %s %s" % [Global.labels[action_type], value])
		# TODO action handling should be done in Global (or dedicated handler)
		match action_type:
			Global.ACTION.SAFE:
				Global.save_people(value)
			Global.ACTION.MOVE_TRAIN:
				Global.move_train(value)
			Global.ACTION.SPEED_UP_TRAIN:
				Global.speed_up_train(value)
			_:
				print("unknown card %s" % card)

func _on_Timer_timeout():
	Global.CURRENT_TRAIN += Global.CURRENT_TRAIN_STEP

func _on_Confirm_pressed():
	draw_new_cards()

func _on_CardSlot1_pressed():
	hand[0].flip()

func _on_CardSlot2_pressed():
	hand[1].flip()
