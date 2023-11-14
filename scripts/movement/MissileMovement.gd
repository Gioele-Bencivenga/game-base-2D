extends RigidBody2D

@export var thrust_speed : Vector2 = Vector2(0, -300)
@export var rotation_speed : float = 3000

signal input_started
signal input_ended

var _is_inputting : bool = false
var _input_direction : Vector2

func _ready():
	angular_damp = 10
	input_ended.emit()


func _integrate_forces(state):
	# has to happen here because we modify constant_torque directly
	# maybe find a way to make it work with add_constant_torque()?
	turn(_input_direction)


func start_input():
	_is_inputting = true
	input_started.emit()


func end_input():
	_is_inputting = false
	input_ended.emit()


func move(input_direction : Vector2):
	apply_force(thrust_speed.rotated(rotation))
	# could call turn(input_direction) here if I figured out add_constant_torque()
	_input_direction = input_direction


func turn(target_direction : Vector2):
	var rot_change = transform.x.dot(position.direction_to(position + target_direction))
	constant_torque = rot_change * rotation_speed


func _on_input_getter_input_gotten(old_input : Vector2, new_input : Vector2):
	if(old_input == Vector2.ZERO 
	and new_input != Vector2.ZERO):
		start_input()
	if(old_input != Vector2.ZERO
	and new_input == Vector2.ZERO):
		end_input()
	if(_is_inputting):
		move(new_input)
