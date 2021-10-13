extends KinematicBody2D

var max_speed = 400
var run_speed = 400
var velocity = Vector2.ZERO

onready var status = p_status.OPERATING

signal died()

enum p_status {
	OPERATING,
	DYING
}

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if status == p_status.OPERATING:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			var ang = lerp_angle(sprite.get_rotation(), input_vector.angle(), delta * 10)
			sprite.set_rotation(ang)
		
		velocity = lerp(velocity, input_vector * run_speed, delta * 10)
		move_and_slide(velocity, Vector2.ZERO)
	if status == p_status.DYING:
		sprite.set_rotation(sprite.get_rotation() + (15 * delta))
		pass


func die():
	status = p_status.DYING
	yield(get_tree().create_timer(1.5), "timeout")
	emit_signal("died")
	queue_free()
