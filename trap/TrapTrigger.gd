extends Area2D


signal triggered(sender)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_trap_triggered")

func on_trap_triggered(obj):
	emit_signal("triggered", self)
#	$CollisionShape2D.call_deferred("set", "disabled", true)
#	$Visuals.hide()
#	yield(get_tree().create_timer(3.0, false), "timeout")
#	$CollisionShape2D.call_deferred("set", "disabled", false)
#	$Visuals.show()
