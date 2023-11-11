class_name PlatformerController extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Exports
@export var move_speed : float = 50
@export var rotation_speed : float = 5
@export var jump_buffer_time : float = 0.5
@export var jump : BaseJump

# Private variables
var _default_direction : Vector2 = Vector2.UP
var _input_direction : Vector2 = _default_direction
var _is_jump_buffered : bool = false
@onready var _jump_buffer_tween : Tween = create_tween()
@onready var _is_on_floor : bool = is_on_floor()
@onready var _is_on_wall : bool = is_on_wall()

signal on_move_ground()
signal on_jump_start()
signal on_jump_end()

func _enter_tree():
	if jump:
		jump.register(self)
	
func _exit_tree():
	if jump:
		jump.unregister()

func _ready():	
	_jump_buffer_tween.tween_callback(
		func() : _is_jump_buffered = true
	)
	_jump_buffer_tween.tween_interval(jump_buffer_time)
	_jump_buffer_tween.tween_callback(
		func() : _is_jump_buffered = false
	)
	_jump_buffer_tween.stop()

func _physics_process(delta):
	_check_floor()
	_check_wall()
	
	_apply_gravity(delta)
	_apply_jump()
	_apply_movement(delta)

func _check_floor():
	if _is_on_floor and not is_on_floor():
		_on_leave_floor()
		
	if not _is_on_floor and is_on_floor():
		_on_touch_floor()
	
	_is_on_floor = is_on_floor()

func _check_wall():
	if _is_on_wall and not is_on_wall():
		_on_leave_wall()
		
	if not _is_on_wall and is_on_wall():
		_on_touch_wall()
	
	_is_on_wall = is_on_wall()

func _apply_gravity(delta):
	if not _is_on_floor:
		velocity.y += gravity * delta

func _apply_movement(_delta):
	if _is_on_floor:
		on_move_ground.emit()
	
	get_input()
	rotation = lerp_angle(rotation, _input_direction.angle(), _delta * rotation_speed)
	velocity = Vector2(1, 0).rotated(rotation) * move_speed
	move_and_slide()
	
func get_input():
	if(Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down")):
		_input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _apply_jump():
	if Input.is_action_just_pressed("jump") or (_is_jump_buffered):
		if _can_jump():
			on_jump_start.emit()
			_stop_jump_buffer()
		else:
			_start_jump_buffer()

	elif Input.is_action_just_released("jump"):
		on_jump_end.emit()

func _on_touch_floor():
	pass
	
func _on_leave_floor():
	pass

func _on_touch_wall():
	pass
	
func _on_leave_wall():
	pass

func _can_jump():
	return true

func _start_jump_buffer():
	if _is_jump_buffered:
		return
		
	_jump_buffer_tween.play()
	
func _stop_jump_buffer():
	_is_jump_buffered = false
	_jump_buffer_tween.stop()
