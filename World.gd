extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_delivered = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$SupplyArea.connect("body_entered", self, "supply_area_entered")
	$UnloadArea.connect("body_entered", self, "unload_area_entered")
	pass # Replace with function body.

func supply_area_entered(obj):
	if (!$Car.loaded):
		$Car.loaded = true

func unload_area_entered(obj):
	if ($Car.loaded):
		$Car.loaded = false
		total_delivered += 1
		$Canvas/DeliveredValueLabel.text = str(total_delivered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
