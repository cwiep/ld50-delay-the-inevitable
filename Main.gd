extends Node2D

var cardbase = load("res://Card.gd")
var cards = [
	cardbase.new(Global.ACTION.MOVE_TRAIN, 5, Global.ACTION.SPEED_UP_TRAIN, 1),
	cardbase.new(Global.ACTION.SAFE, 10, Global.ACTION.SAFE, 5),
	cardbase.new(Global.ACTION.SPEED_UP_TRAIN, 1, Global.ACTION.MOVE_TRAIN, 2),
	cardbase.new(Global.ACTION.MOVE_TRAIN, 10, Global.ACTION.SAFE, 2),
]
var trash = []
var hand = []

func _ready():
	$Progress.max_value = Global.MAX_TRAIN
	randomize()
	draw_new_cards()

func _process(_delta):
	$Progress.value = Global.CURRENT_TRAIN
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
		if cards.size() > 0:
			var card = cards.pop_front()
			print("drawn: " + str(card))
			hand.append(card)
		else:
			_shuffle_deck()
			
	print("deck size: " + str(cards.size()))
	_update_ui()
	
func _shuffle_deck():
	print("shuffling deck")
	while trash.size() > 0:
		cards.append(trash.pop_front())
	cards.shuffle()
	
func _update_ui():
	$Cards/Label.text = "Deck: " + str(cards.size())
	$Cards/Saved.text = "Saved: " + str(Global.saved)
	$Cards/CardSlot1.text = Global.labels[hand[0].get_action()] + " " + str(hand[0].get_value())
	$Cards/CardSlot2.text = Global.labels[hand[1].get_action()] + " " + str(hand[1].get_value())
	$Cards/CardSlot3.text = Global.labels[hand[2].get_action()] + " " + str(hand[2].get_value())

func _apply_card(card):
	var action = card.get_action()
	var value = card.get_value()
	print("using %s %s" % [Global.labels[action], value])
	# TODO action handling should be done in Global (or dedicated handler)
	match card.get_action():
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

func _on_CardSlot3_pressed():
	hand[2].flip()
