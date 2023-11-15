extends Node

signal input_started(input : Vector2)
signal input_present(input : Vector2)
signal input_ended()

var _last_input_dir : Vector2


func _ready():
	_last_input_dir = Vector2.ZERO


func _process(delta):
	get_input()


func get_input():
	var curr_input_dir = Vector2.ZERO
	curr_input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(curr_input_dir != Vector2.ZERO):
		if(_last_input_dir == Vector2.ZERO):
			input_started.emit(curr_input_dir)
		else :
			input_present.emit(curr_input_dir)
	elif(curr_input_dir == Vector2.ZERO
	and _last_input_dir != Vector2.ZERO):
		input_ended.emit()
	_last_input_dir = curr_input_dir
