extends Node

const MAX_TRAIN = 100
var CURRENT_TRAIN = 0
var CURRENT_TRAIN_STEP = 1
var saved = 0

enum ACTION {
	MOVE_TRAIN,
	SPEED_UP_TRAIN,
	SAFE
}

const labels = {
	ACTION.MOVE_TRAIN: "Move Train",
	ACTION.SPEED_UP_TRAIN: "Speed Up",
	ACTION.SAFE: "Safe"
}

func reset():
	CURRENT_TRAIN = 0
	CURRENT_TRAIN_STEP = 1
	saved = 0

func move_train(value):
	CURRENT_TRAIN = max(CURRENT_TRAIN + value, 0)

func speed_up_train(value):
	CURRENT_TRAIN_STEP = max(CURRENT_TRAIN_STEP + value, 1)

func save_people(value):
	saved = max(saved + value, 0)
