extends KinematicBody2D

export(NodePath) var navigation_node_path = null
export(Vector2) var destination = null setget set_destination

var navigation:Navigation2D
var path = []
var free_position = null

var run_speed = 250
var velocity = Vector2.ZERO

var target = null

onready var spawn_position = position
onready var sprite = $drone_sm
onready var ray_cast = $RayCast2D
onready var animation_player = $AnimationPlayer

signal path_ended(sender)


# Called when the node enters the scene tree for the first time.
func _ready():
	if navigation_node_path != null:
		navigation = get_node(navigation_node_path)
	
	path = navigation.get_simple_path(position, destination, false)
	
	$drone_sm/Atack.connect("body_entered", self, "on_attack_hit")
	
	pass # Replace with function body.

func on_attack_hit(body):
	body.die()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !path.empty():
		var next_pos = path[0]
		
		var direction = (next_pos - position).normalized()
		if direction != Vector2.ZERO:
			var ang = lerp_angle(sprite.get_rotation(), direction.angle(), delta * 10)
			sprite.set_rotation(ang)
		
		velocity = lerp(velocity, direction * run_speed, delta * 10)
		move_and_slide(velocity, Vector2.ZERO)
		
		if !animation_player.is_playing() and position.distance_to(target.position) < 250:
			animation_player.play("Atack", -1, 1.5)
		
		if (position.distance_to(next_pos)) < 30: # chegou no próximo ponto do caminho
			if ray_cast.get_collider() == target: # se está vendo o alvo
				set_destination(ray_cast.get_collision_point()) # atualiza caminho até o alvo
			path.remove(0)
		if free_position != null and position.distance_to(free_position) < 30:
			queue_free()
	else:
		emit_signal("path_ended", self)
	
#	update()

func _physics_process(delta):
	if target != null and is_instance_valid(target):
		ray_cast.cast_to = target.position - position
	pass

func set_destination(dest):
	destination = dest
	if navigation != null:
		path = navigation.get_simple_path(position, destination, false)


#func _draw():
#
#	draw_circle(position, 50, Color(1,1,1))
#	draw_circle(destination, 50, Color(1,1,1))
#
#	if path.size() > 2:
#		for point in path:
#			draw_circle(point, 10, Color(1,1,1))
#		draw_polyline(path, Color(1,0,0), 3.0, true)
