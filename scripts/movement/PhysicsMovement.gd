extends RigidBody2D

@export var thrust_speed : Vector2 = Vector2(0, -300)

signal input_started
signal input_ended

var _is_inputting : bool = false

func _ready():
	input_ended.emit()


func start_input():
	_is_inputting = true
	input_started.emit()


func end_input():
	_is_inputting = false
	input_ended.emit()


func move(_input_direction : Vector2):
	apply_force(_input_direction * thrust_speed.length())


func _on_input_getter_input_changed(old_input : Vector2, new_input : Vector2):
	if(old_input == Vector2.ZERO 
	and new_input != Vector2.ZERO):
		start_input()
	if(old_input != Vector2.ZERO
	and new_input == Vector2.ZERO):
		end_input()
	if(_is_inputting):
		move(new_input)
