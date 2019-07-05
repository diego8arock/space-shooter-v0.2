extends Node2D
class_name EnemySteering, "res://core/movement/EnemySteering.gd"

onready var parent: Enemy = get_parent()
const EMPTY_VECTOR2 = Vector2()

#https://gamedevelopment.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732
#https://natureofcode.com/book/chapter-6-autonomous-agents/
#https://www.red3d.com/cwr/steer/
func steer() -> void:
	parent.steering = parent.steering.clamped(parent.max_force)
	parent.steering = parent.steering / parent.mass
	parent.velocity = (parent.velocity + parent.steering).clamped(TimeManager.adjust_speed(parent.max_velocity))
	parent.global_position += parent.velocity

func nothing() -> void:
	
	parent.steering = Vector2()

func seek(_target: Vector2) -> void:
	
	parent.desired_velocity = (_target - parent.global_position).normalized() * TimeManager.adjust_speed(parent.max_velocity)	
	parent.steering += parent.desired_velocity - parent.velocity
	
func flee(_target: Vector2) -> void:
	
	parent.desired_velocity = (parent.global_position - _target).normalized() * TimeManager.adjust_speed(parent.max_velocity)
	parent.steering += parent.desired_velocity - parent.velocity

func arrival(_target: Vector2, _radius: float) -> void:
		
	parent.desired_velocity = _target - parent.global_position
	var distance = parent.desired_velocity.length()
	parent.desired_velocity = parent.desired_velocity.normalized() * TimeManager.adjust_speed(parent.max_velocity)
	parent.desired_velocity *= (distance / _radius) if  distance < _radius else 1
	parent.steering += parent.desired_velocity - parent.velocity
	
func wander() -> void:
	
	var circle_center: Vector2
	circle_center = FunctionManager.clone_vector2(parent.velocity)
	circle_center = circle_center.normalized()
	circle_center *= parent.wander_offset.position.x
	
	var displacement: Vector2
	displacement = Vector2(0, -1)
	displacement *= (parent.wander_offset.shape as CircleShape2D).radius	
	
	var length = displacement.length()
	displacement.x = cos(parent.wander_angle) * length
	displacement.y = sin(parent.wander_angle) * length
	
	parent.wander_angle += deg2rad(randf() * parent.angle_change - parent.angle_change * 0.5)
	
	var wander_force: Vector2
	wander_force = circle_center + displacement
	parent.desired_velocity = wander_force
	parent.steering += wander_force		

func pursuit(_target_global_position: Vector2, _target_velocity: Vector2, _target_max_speed: float) -> void:
	
	var future_position: Vector2 = _target_position_prediction(_target_global_position, _target_velocity, _target_max_speed)
	seek(future_position)

func evade(_target_global_position: Vector2, _target_velocity: Vector2, _target_max_speed: float) -> void:
	
	var future_position: Vector2 = _target_position_prediction(_target_global_position, _target_velocity, _target_max_speed)
	flee(future_position)
	
func avoidance(_ray_cast_center: RayCast2D, _ray_cast_left: RayCast2D, _ray_cast_right: RayCast2D) -> void:
	
	var avoidance_force = Vector2()
	
	#Center ray cast has priority
	_set_avoidance_ray_cast_length(_ray_cast_center)
	avoidance_force = _obstacle_avoidance(_ray_cast_center)
	
	#Check left ray cast
	if avoidance_force == EMPTY_VECTOR2:
		_set_avoidance_ray_cast_length(_ray_cast_left, 0.5)
		avoidance_force = _obstacle_avoidance(_ray_cast_left, 0.5)

	#Check right ray cast
	if avoidance_force == EMPTY_VECTOR2:
		_set_avoidance_ray_cast_length(_ray_cast_right, 0.5)
		avoidance_force = _obstacle_avoidance(_ray_cast_right, 0.5)
		
	parent.steering += avoidance_force

#Private
func _set_avoidance_ray_cast_length(_ray_cast: RayCast2D, _see_ahead_multiplier: float = 1.0) -> void:
	_ray_cast.cast_to = parent.desired_velocity.normalized() * parent.max_see_ahead * _see_ahead_multiplier
	
func _obstacle_avoidance(_ray_cast: RayCast2D, _see_ahead_multiplier: float = 1.0) -> Vector2:
	
	var avoidance_force = Vector2()
	if _ray_cast.is_colliding():		
		var collider = _ray_cast.get_collider()
		if collider.is_in_group(GroupManager.OBSTACLES_GROUP):	
			var normal = _ray_cast.get_collision_normal()	
			var point = _ray_cast.get_collision_point()
			var see_ahead = parent.max_see_ahead * _see_ahead_multiplier
			avoidance_force = normal.rotated(PI/2) * (see_ahead * 0.5)  * (1 - global_position.distance_to(point) / see_ahead)
	return avoidance_force

func _target_position_prediction(_target_global_position: Vector2, _target_velocity: Vector2, _target_max_speed: float) -> Vector2:
	
	var distance: Vector2 = _target_global_position - parent.global_position
	var T: int = int(distance.length() / _target_max_speed)
	var future_position: Vector2 = _target_global_position + _target_velocity * T
	return future_position
	
	
	