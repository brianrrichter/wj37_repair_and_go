extends KinematicBody2D


var wheel_base = 35 #70 # distance between 2 wheels
var steering_angle = 15 # amount that wheel turns in degrees
var engine_power = 800
var friction = -0.9
var drag = -0.001
var braking = -450
var max_speed_reverse = 250

var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7


var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction = 0

var loaded = false setget loaded_set


# Called when the node enters the scene tree for the first time.
func _ready():
	update_load_indicator()
	pass # Replace with function body.

func loaded_set(l):
	loaded = l
	update_load_indicator()

func update_load_indicator():
	$LoadIndicator.visible = loaded

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_key_pressed(KEY_D):
		turn += 1
	if Input.is_key_pressed(KEY_A):
		turn -= 1
	
	steer_direction = turn * deg2rad(steering_angle)
	
	if Input.is_key_pressed(KEY_W):
		acceleration = transform.x * engine_power
	if Input.is_key_pressed(KEY_S):
		acceleration = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	
	rotation = new_heading.angle()

