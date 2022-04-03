class_name Card
extends Node

var _name: String
var _front_actions: Array
var _back_actions: Array
var _cost_type
var _cost = 0
var _paid_actions: Array
var _flipped = false

func _init(name: String, front_actions: Array, back_actions: Array, cost: int, cost_type, paid_actions: Array):
	self._name = name
	self._front_actions = front_actions
	self._back_actions = back_actions
	self._cost_type = cost_type
	self._cost = cost
	self._paid_actions = paid_actions

func get_name() -> String:
	return _name

func get_actions() -> Array:
	if _flipped:
		return _back_actions
	return _front_actions
	
func get_paid_actions() -> Array:
	return _paid_actions
	
func get_cost() -> int:
	return _cost
	
func get_cost_type():
	return _cost_type
	
func flip() -> void:
	_flipped = !_flipped

func _to_string():
	return "Card (front=%s, back=%s)" % [_front_actions, _back_actions]
