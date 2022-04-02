extends Node

var action
var value
var back_action
var back_value
var flipped = false

func _init(action, value, back_action, back_value):
	self.action = action
	self.value = value
	self.back_action = back_action
	self.back_value = back_value

func get_action():
	if flipped:
		return back_action
	return action

func get_value():
	if flipped:
		return back_value
	return value
	
func flip():
	flipped = !flipped

func _to_string():
	return "Card (action=%s, value=%s, back_action=%s, back_value=%s)" % [Global.labels[action], value, Global.labels[back_action], back_value]
