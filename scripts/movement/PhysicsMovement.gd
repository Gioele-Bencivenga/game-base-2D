extends RigidBody2D

@export var max_speed : int = 500
@export var thrust_speed : Vector2 = Vector2(0, -500)


func _integrate_forces(state):
	# this speed limit can still be exceeded if the body is affected by external forces
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= max_speed
		set_linear_velocity(new_speed)


func move(_input_direction : Vector2):
	apply_force(_input_direction * thrust_speed.length())


func _on_input_component_input_started(input : Vector2):
	move(input)


func _on_input_component_input_present(input : Vector2):
	move(input)


func _on_input_component_input_ended():
	pass
