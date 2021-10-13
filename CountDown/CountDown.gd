extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = $Label
onready var status = p_status.COUNTING

var current_time = 25.0

signal time_up()

enum p_status {
	COUNTING,
	STOPPED,
	DEACTIVATED
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func deactivate():
	status = p_status.DEACTIVATED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if status == p_status.COUNTING and current_time <= 0:
		status = p_status.STOPPED
		emit_signal("time_up")
	elif status == p_status.COUNTING:
		current_time -= delta
		label.text = str(current_time)
	elif status == p_status.STOPPED:
		label.text = 'TIME UP!!!'



