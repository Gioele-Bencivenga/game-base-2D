extends RigidBody2D

@export var thrust_speed : Vector2 = Vector2(0, -300)
@export var rotation_speed : float = 3000

signal input_started
signal input_ended

var _default_direction : Vector2 = Vector2.UP
var _input_direction : Vector2 = _default_direction
var _is_inputting : bool = false

func _ready():
	input_ended.emit()
	angular_damp = 10

func _process(delta):
	get_input()
	

func _integrate_forces(state):
	move()
	turn()


func get_input():
	if(Input.is_action_pressed("move_left") 
	or Input.is_action_pressed("move_right") 
	or Input.is_action_pressed("move_up") 
	or Input.is_action_pressed("move_down")):
		start_input()
	if(!Input.is_action_pressed("move_left")
	and !Input.is_action_pressed("move_right") 
	and !Input.is_action_pressed("move_up") 
	and !Input.is_action_pressed("move_down")):
		end_input()


func start_input():
	if(_is_inputting == false):
		_is_inputting = true
		input_started.emit()


func end_input():
	if(_is_inputting == true):
		_is_inputting = false
		input_ended.emit()


func move():
	if(_is_inputting):
		_input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		apply_force(thrust_speed.rotated(rotation))
		
		
func turn():
	if(_is_inputting):
		# dot prod between where we are and where we want to go
		var rot = transform.x.dot(position.direction_to(position + _input_direction))
		constant_torque = rot * rotation_speed
