extends Area2D


export(bool) var initial_state_on
var on setget set_on

signal state_changed(state)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_on(initial_state_on)
	
	connect("body_entered", self, "on_body_entered")
	pass # Replace with function body.

func set_on(val):
	if val == null:
		val = false
	on = val
	if on:
		$SpriteOff.hide()
		$SpriteOn.show()
	else:
		$SpriteOn.hide()
		$SpriteOff.show()

func on_body_entered(body):
	set_on(!on)
	emit_signal("state_changed", on)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
