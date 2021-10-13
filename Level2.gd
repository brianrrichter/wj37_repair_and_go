extends Node2D

var enemy_scn = preload("res://enemy/Enemy.tscn")

onready var player = $Navigation2D/Player
onready var count_down = $Navigation2D/InBetween/CountDown
onready var label = $CanvasLayer2/Label
onready var terminal_self_destruct = $TerminalSelfDestruct

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	$AudioStreamPlayer2D.play()

	$Terminal.connect("state_changed", $Porta, "change_lock_status")
	
	$TrapTrigger.connect("triggered", self, "trap_triggered")
	$TrapTrigger2.connect("triggered", self, "trap_triggered")
	player.connect("died", self, "on_player_died")
	count_down.connect("time_up", self, "on_time_out")
	terminal_self_destruct.connect("state_changed", self, "on_terminal_self_destruct_state_changed")
	
	label.hide()
	
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.scancode == KEY_R and event.pressed == false:
		get_tree().reload_current_scene()

func on_terminal_self_destruct_state_changed(status):
	label.show()
	label.text = "YOU STOPPED THE SELF DESTRUCTION\nHIT 'R' TO RESTART\nTHANKS FOR PLAYING!!!"
	count_down.deactivate()
	for e in $Navigation2D/Enemies.get_children():
		e.queue_free()

func on_time_out():
	label.show()
	label.text = "TIME UP!!!!"
	if player.status == player.p_status.OPERATING:
		player.die()

func on_enemy_path_ended(sender):
#	$Enemy.destination = $Navigation2D/Player.position
	sender.destination = sender.spawn_position
	sender.free_position = sender.spawn_position
	pass

func trap_triggered(sender):
	if $Navigation2D/Enemies.get_child_count() <= 0:
		create_enemy(sender.position)

func on_player_died():
	get_tree().reload_current_scene()

func create_enemy(pos):
	var enemy_instance = enemy_scn.instance()
	enemy_instance.position = $Navigation2D/InBetween/EnemyDummy.position
	enemy_instance.destination = pos
	enemy_instance.navigation = $Navigation2D
	enemy_instance.target = player
	enemy_instance.connect("path_ended", self, "on_enemy_path_ended");
	$Navigation2D/Enemies.add_child(enemy_instance)
	

func _process(delta):
#	update()
	pass


#func _draw():
##	draw_circle($Enemy.position, 50, Color(1,1,1))
##	draw_circle($Enemy.destination, 50, Color(1,1,1))
#	if $Enemy.path.size() > 2:
#		for point in $Enemy.path:
#			draw_circle(point, 10, Color(1,1,1))
#		draw_polyline($Enemy.path, Color(1,0,0), 3.0, true)
