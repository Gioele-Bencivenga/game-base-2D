extends RigidBody2D

# get rid of this by creating an input component
@export var isPlayer : bool = false
@export_group("Movement")
@export var target : RigidBody2D
@export var max_speed : int = 300
@export var thrust_speed : Vector2 = Vector2(0, -300)
@export var rotation_speed : float = 3000
@export var dash_speed : int = 1000
@export var dash_cooldown : float = 2.0
@export var rigidbody: RigidBody2D

var _can_dash = true
var _is_hovering = false

var _spacebar_pressed : bool = false
var _is_inputting : bool = false
var _input_direction : Vector2

func _ready():
	angular_damp = 10

func _integrate_forces(state):
	# this speed limit can still be exceeded if the body is affected by external forces
	# the above statement doesn't seem to be true though
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= max_speed
		set_linear_velocity(new_speed)
	if(_is_inputting or _is_hovering):
		# has to happen here because we modify constant_torque directly
		# maybe find a way to make it work with add_constant_torque()?
		turn(_input_direction)
		

func _process(delta: float) -> void:
	if _is_hovering and isPlayer:
		move(Vector2(0, -1), thrust_speed/4.5)
	if target:
		var direction = (target.position - self.position).normalized()
		move(direction, thrust_speed)
	

func move(input_direction : Vector2, speed : Vector2):
	# could call turn(input_direction) here if I figured out add_constant_torque()
	_input_direction = input_direction
	if Input.is_action_pressed("spacebar_pressed") and isPlayer == true:
		if _can_dash:
			_can_dash = false
			get_tree().create_timer(dash_cooldown).timeout.connect(func(): _can_dash = true)
			apply_central_impulse(_input_direction * dash_speed)
	apply_force(speed.rotated(rotation))
	

func turn(target_direction : Vector2):
	var rot_change = transform.x.dot(position.direction_to(position + target_direction))
	constant_torque = rot_change * rotation_speed


func _on_input_component_input_started(input : Vector2):
	_is_inputting = true
	move(input, thrust_speed)
	_is_hovering = false


func _on_input_component_input_present(input : Vector2):
	_is_inputting = true
	move(input, thrust_speed)
	_is_hovering = false


func _on_input_component_input_ended():
	_is_inputting = false
	get_tree().create_timer(1.5).timeout.connect(func(): _is_hovering = true)
