extends Area2D

export (NodePath) var player_path
var player: Player

var velocity: Vector2 = Vector2(1,0)
var desired_velocity: Vector2
var steering: Vector2
var max_speed: float = 2.0
var max_force: float =  1.0
var mass = 2.0
var distance: float = 0.0
var wander_angle: float =  0.0

const ANGLE_CHANGE: float = 45.0

onready var debug_pivot = $DebugPivot
onready var debug = $DebugPivot/SimpleDebug


onready var wander_offset = $WanderOffset

func _ready() -> void:
	player = get_node(player_path)
	debug.add_label("distance")
	debug.add_label("az_radius")
	debug.add_label("slowing")	
	debug.add_label("desired_velocity")
	
	debug.add_label("circle_center")
	debug.add_label("displacement")
	debug.add_label("wander_angle")
	debug.add_label("wander_force")

#https://gamedevelopment.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732
#https://natureofcode.com/book/chapter-6-autonomous-agents/
#https://www.red3d.com/cwr/steer/	
func _process(delta: float) -> void:
	
	debug_pivot.global_rotation = 0
	
	#steering = arrival(player.global_position, player.get_attack_zone_radius())
	#steering = seek(player.global_position)
	#steering = wander()
	#steering = flee(player.global_position)
	#steering = pursuit(player)
	steering = evade(player)
	steering = steering.clamped(max_force)
	steering = steering / mass
	velocity = (velocity + steering).clamped(TimeManager.adjust_speed(max_speed))
	global_position += velocity
	global_rotation = velocity.angle()
	
func seek(_target: Vector2) -> Vector2:
	velocity = (_target - global_position) * TimeManager.adjust_speed(max_speed)
	desired_velocity = (_target - global_position).normalized() * TimeManager.adjust_speed(max_speed)
	return desired_velocity - velocity
	
func flee(_target: Vector2) -> Vector2:
	desired_velocity = (global_position - _target).normalized() * TimeManager.adjust_speed(max_speed)
	return desired_velocity - velocity
	
func arrival(_target: Vector2, _radius: float) -> Vector2:
		
	velocity = (_target - global_position) * TimeManager.adjust_speed(max_speed)
	desired_velocity = _target - global_position
	distance = desired_velocity.length()
	
	debug.update_label("distance", str(distance))
	debug.update_label("az_radius", str(_radius))
	if distance < _radius:
		desired_velocity = desired_velocity.normalized() * TimeManager.adjust_speed(max_speed) * (distance / _radius)
		debug.update_label("slowing", "true")
	else:
		desired_velocity = desired_velocity.normalized() * TimeManager.adjust_speed(max_speed)
		debug.update_label("slowing", "false")
	debug.update_label("desired_velocity", str(desired_velocity))
	
	return desired_velocity - velocity
	
func wander() -> Vector2:
	
	var circle_center: Vector2
	circle_center = Vector2(velocity.x, velocity.y)
	circle_center = circle_center.normalized()
	circle_center *= wander_offset.position.x
	debug.update_label("circle_center", str(circle_center))
	
	var displacement: Vector2
	displacement = Vector2(0, -1)
	displacement *= (wander_offset.shape as CircleShape2D).radius	
	
	var length = displacement.length()
	displacement.x = cos(wander_angle) * length
	displacement.y = sin(wander_angle) * length
	debug.update_label("displacement", str(displacement))
	
	wander_angle += deg2rad(randf() * ANGLE_CHANGE - ANGLE_CHANGE * 0.5)
	debug.update_label("wander_angle", str(wander_angle))
	
	var wander_force: Vector2
	wander_force = circle_center + displacement
	debug.update_label("wander_force", str(wander_force))
	return wander_force		

func pursuit(_target: Player) -> Vector2:
	var distance: Vector2 = _target.global_position - global_position
	var T: int = int(distance.length() / _target.MAX_SPEED)
	var future_position: Vector2 = _target.global_position + _target.velocity * T;
	return seek(future_position)
	
func evade(_target: Player) -> Vector2:
	var distance: Vector2 = _target.global_position - global_position
	var T: int = int(distance.length() / _target.MAX_SPEED)
	var future_position: Vector2 = _target.global_position + _target.velocity * T;
	return flee(future_position)
	
	
	
	
