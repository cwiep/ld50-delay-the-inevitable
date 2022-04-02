extends Node2D

const HAND_SIZE = 2

var deck = []
var trash = []
var hand = []

func _ready():
	$Progress.max_value = Global.MAX_TRAIN
	randomize()
	deck = _import_cards()
	draw_new_cards()

func _import_cards() -> Array:
	print("reading json file")
	var file = File.new()
	file.open("res://cards.tres", file.READ)
	var text = file.get_as_text()
	var result = JSON.parse(text)
	print("errors: %s %s %s" % [result.error, result.error_line, result.error_string])
	file.close()
	print(result.result)
	
	var cards = []
	for card in result.result:
		var qty = card["quantity"]
		for _i in range(qty):
			var front = []
			for f in card["front"]:
				front.append([Global.ACTION.get(f["type"]), f["value"]])
			
			var back = []
			for b in card["back"]:
				back.append([Global.ACTION.get(b["type"]), b["value"]])
				
			var inst = Card.new(front, back)
			print("adding ", inst)
			cards.append(inst)
		
	return cards

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
	while hand.size() < HAND_SIZE:
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
	$Step.text = "Step %s" % Global.CURRENT_TRAIN_STEP
	$Cards/DeckSize.text = "Deck: " + str(deck.size())
	$Cards/TrashSize.text = "Discarded: " + str(trash.size())
	$Cards/Saved.text = "Saved: " + str(Global.saved)
	$Cards/CardSlot1/Label.text = _generate_card_text(hand[0])
	$Cards/CardSlot2/Label.text = _generate_card_text(hand[1])

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
	# Global.CURRENT_TRAIN += Global.CURRENT_TRAIN_STEP
	pass

func _on_Confirm_pressed():
	$SelectPlayer.play()
	Global.CURRENT_TRAIN += Global.CURRENT_TRAIN_STEP
	draw_new_cards()
	if Global.CURRENT_TRAIN >= Global.MAX_TRAIN:
		get_tree().change_scene("res://GameOver.tscn")

func _on_CardSlot1_pressed():
	hand[0].flip()

func _on_CardSlot2_pressed():
	hand[1].flip()
