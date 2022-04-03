class_name Card
extends Node

var _name: String
var _front_actions: Array
var _back_actions: Array
var _flipped = false

func _init(name: String, front_actions: Array, back_actions: Array):
	self._name = name
	self._front_actions = front_actions
	self._back_actions = back_actions

func get_name() -> String:
	return _name

func get_actions() -> Array:
	if _flipped:
		return _back_actions
	return _front_actions
	
func flip() -> void:
	_flipped = !_flipped

func _to_string():
	return "Card (front=%s, back=%s)" % [_front_actions, _back_actions]
