extends Node2D

const HAND_SIZE = 2

var deck = []
var trash = []
var hand = []

func _ready():
	Global.reset()
	$Progress.max_value = Global.MAX_TRAIN
	randomize()
	deck = _import_cards()
	deck.shuffle()
	draw_new_cards()

func _import_cards() -> Array:
	print("reading json file")
	var file = File.new()
	file.open("res://cards.json", file.READ)
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
				
			var paid = []
			var cost = 0
			var cost_type
			if card.has("paid"):
				cost = card["paid"]["cost"]
				cost_type = Global.COST_TYPE.get(card["paid"]["type"])
				for p in card["paid"]["actions"]:
					paid.append([Global.ACTION.get(p["type"]), p["value"]])
				
			var inst = Card.new(card["name"], front, back, cost, cost_type, paid)
			print("adding ", inst)
			cards.append(inst)
		
	return cards

func _process(_delta):
	_update_ui()
	
func _input(event):
	if event.is_echo():
		return
	if event.is_action_pressed("choose_left"):
		_on_choose_left_pressed()
	elif event.is_action_pressed("choose_right"):
		_on_choose_right_pressed()

func draw_new_cards():
	# remove current hand
	while !hand.empty():
		trash.append(hand.pop_front())
		
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
	$TextureProgress.value = Global.CURRENT_TRAIN
	$PeopleSaved.text = str(Global.saved)
	$ManaValue.text = str(Global.mana)
	$DeckSize.text = str(deck.size())
	$Cards/CardSlot1.set_card(hand[0])
	$Cards/CardSlot2.set_card(hand[1])

func _apply_card(card: Card) -> void:
	for action in card.get_actions():
		_perform_action(action)
		
	if card.get_cost() > 0:
		var cost = card.get_cost()
		var cost_type = card.get_cost_type()
		match card.get_cost_type():
			Global.COST_TYPE.MANA:
				if Global.mana >= cost:
					Global.change_mana(-cost)
					for action in card.get_paid_actions():
						_perform_action(action)
			Global.COST_TYPE.PEOPLE:
				if Global.saved >= cost:
					Global.save_people(-cost)
					for action in card.get_paid_actions():
						_perform_action(action)
			_:
				print("unknown cost type %s", cost_type)

func _perform_action(action):
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
		Global.ACTION.MANA:
			Global.change_mana(value)
		_:
			print("unknown action %s", action)

func _on_choose_left_pressed():
	$Cards/CardSlot1/Button/AnimationPlayer.play("select")
	$SelectCardSound.play()
	_apply_card(hand[0])

func _on_choose_right_pressed():
	$Cards/CardSlot2/Button/AnimationPlayer.play("select")
	$SelectCardSound.play()
	_apply_card(hand[1])

func _on_SelectCardSound_finished():
	Global.CURRENT_TRAIN += Global.CURRENT_TRAIN_STEP
	draw_new_cards()
	if Global.CURRENT_TRAIN >= Global.MAX_TRAIN:
		var _ignore = get_tree().change_scene("res://scenes/GameOver.tscn")
