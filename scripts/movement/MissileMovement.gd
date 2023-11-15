extends RigidBody2D

@export var max_speed : int = 200
@export var thrust_speed : Vector2 = Vector2(0, -300)
@export var rotation_speed : float = 3000

var _is_inputting : bool = false
var _input_direction : Vector2

func _ready():
	angular_damp = 10


func _integrate_forces(state):
	# this speed limit can still be exceeded if the body is affected by external forces
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= max_speed
		set_linear_velocity(new_speed)
	if(_is_inputting):
		# has to happen here because we modify constant_torque directly
		# maybe find a way to make it work with add_constant_torque()?
		turn(_input_direction)


func move(input_direction : Vector2):
	apply_force(thrust_speed.rotated(rotation))
	# could call turn(input_direction) here if I figured out add_constant_torque()
	_input_direction = input_direction


func turn(target_direction : Vector2):
	var rot_change = transform.x.dot(position.direction_to(position + target_direction))
	constant_torque = rot_change * rotation_speed


func _on_input_component_input_started(input : Vector2):
	_is_inputting = true
	move(input)


func _on_input_component_input_present(input : Vector2):
	move(input)


func _on_input_component_input_ended():
	_is_inputting = false
