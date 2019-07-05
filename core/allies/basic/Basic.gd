extends Area2D

export (NodePath) var player_path
var player: Player

export (NodePath) var allies_path
var allies

onready var debug = $SimpleDebug
onready var sprite = $Sprite

var steering: Vector2
const LEADER_BEHIND_DIST: float = 50.0
const SEPARATION_RADIUS: float = 50.0
const MAX_SEPARATION: float = 30.0
var desired_velocity: Vector2
var max_velocity: float = 5.0
var velocity: Vector2
var mass: float = 1.7
var max_force: float = 0.3

func _ready() -> void:
	
	player = get_node(player_path)
	allies = get_node(allies_path).get_children()

func _process(delta: float) -> void:
	
	steering = nothing()
	steering += arrival(follow(), player.get_attack_zone_radius())
	steering += separation()
	steering = steering.clamped(max_force)
	steering = steering / mass
	velocity = (velocity + steering).clamped(TimeManager.adjust_speed(max_velocity))
	global_position += velocity	
	sprite.rotation = desired_velocity.angle() + deg2rad(90)	

func nothing() -> Vector2:
	
	return Vector2()
	
func follow() -> Vector2:
	
	var tv = FunctionManager.clone_vector2(player.velocity)
	tv *= -1
	tv = tv.normalized()
	tv *= LEADER_BEHIND_DIST
	var behind = player.global_position + tv
	return behind
	
func arrival(_target: Vector2, _radius: float) -> Vector2:
		
	desired_velocity = _target - global_position
	var distance = desired_velocity.length()
	desired_velocity = desired_velocity.normalized() * TimeManager.adjust_speed(max_velocity)
	desired_velocity *= (distance / _radius) if  distance < _radius else 1
	return desired_velocity - velocity
	
func separation() -> Vector2:
	
	var neighboor_count: int = 0
	var force: Vector2 = Vector2()
	
	for a in allies:
		if a != self:
			if global_position.distance_to(a.global_position) <= SEPARATION_RADIUS:
				force += a.global_position - global_position
				neighboor_count += 1
				
	if neighboor_count != 0:
		force /= neighboor_count
		force *= -1
		
	force.normalized()
	force *= MAX_SEPARATION
	return force

	
	
	
