extends StaticBody2D


export(bool) var locked = false setget set_locked
export(bool) var open = false setget set_open

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if open:
		$AnimationPlayer.play("Open")
	else:
		$AnimationPlayer.play("Close")
	
	$InteractionArea.connect("body_entered", self, "on_body_entered_area")
	pass # Replace with function body.


func on_body_entered_area(obj):
	if !open and !locked:
		set_open(true)

func set_open(open_val):
	open = open_val
	if open:
		$AnimationPlayer.play("Open")
	else:
		$AnimationPlayer.play("Close")

func set_locked(val):
	locked = val
	if locked:
		$IndicatorLocked.show()
		$IndicatorUnlocked.hide()
	else:
		$IndicatorLocked.hide()
		$IndicatorUnlocked.show()

func change_lock_status(status):
	var loc = !status
	set_locked(loc)
	if loc and open:
		set_open(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
