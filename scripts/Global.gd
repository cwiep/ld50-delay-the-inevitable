extends Node

const MAX_TRAIN = 100
var CURRENT_TRAIN = 0
var CURRENT_TRAIN_STEP = 1
var saved = 0
var mana = 0

enum ACTION {
	MOVE_TRAIN,
	SPEED_UP_TRAIN,
	SAFE,
	MANA
}

enum COST_TYPE {
	MANA,
	PEOPLE
}

const labels = {
	ACTION.MOVE_TRAIN: "Advance",
	ACTION.SPEED_UP_TRAIN: "Accelerate",
	ACTION.SAFE: "Evacuate",
	ACTION.MANA: "Mana",
}

const cost_labels = {
	COST_TYPE.MANA: "Mana",
	COST_TYPE.PEOPLE: "Saved"
}

func reset():
	CURRENT_TRAIN = 0
	CURRENT_TRAIN_STEP = 1
	saved = 0
	mana = 0

func move_train(value):
	CURRENT_TRAIN = max(CURRENT_TRAIN + value, 0)

func speed_up_train(value):
	CURRENT_TRAIN_STEP = max(CURRENT_TRAIN_STEP + value, 1)

func save_people(value):
	saved = max(saved + value, 0)
	
func change_mana(value):
	mana = max(mana + value, 0)
