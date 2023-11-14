extends Node

signal input_gotten(old_input : Vector2, new_input : Vector2)

var _input_direction : Vector2
var _is_inputting : bool


func _ready():
	_is_inputting = false
	_input_direction = Vector2.ZERO


func _process(delta):
	get_input()


func get_input():
	var old_input = _input_direction
	var curr_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(curr_input):
		_input_direction = curr_input
	else:
		_input_direction = Vector2.ZERO
	var new_input = _input_direction
	input_gotten.emit(old_input, new_input)
