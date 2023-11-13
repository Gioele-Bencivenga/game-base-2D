extends RigidBody2D

@export var speed : float = 300

var _default_direction : Vector2 = Vector2.UP
var _input_direction : Vector2 = _default_direction

func _process(delta):
	get_input()
		
	move()

func get_input():
	if(Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down")):
		_input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func move():
	if(Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down")):
		apply_force(_input_direction * speed)
