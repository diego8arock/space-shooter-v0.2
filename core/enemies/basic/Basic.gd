extends Enemy

export (NodePath) var player_path
var player: Player

onready var enemy_steering: EnemySteering = $EnemySteering

onready var debug_pivot = $DebugPivot
onready var debug = $DebugPivot/SimpleDebug

onready var collision = $CollisionPolygon2D
onready var sprite = $Sprite
onready var ray_cast_center = $RayCast2DCenter
onready var ray_cast_left = $RayCast2DLeft
onready var ray_cast_right = $RayCast2DRight

func _ready() -> void:
	
	player = get_node(player_path)
	
	max_force = 1.0
	max_velocity =  3.0
	mass =  2.0
	angle_change = 2.0
	wander_offset = $WanderOffset
	wander_angle = 0.0
	max_see_ahead = 100.0
	
func _process(delta: float) -> void:
	
	debug_pivot.global_rotation = 0	
	
	if not TimeManager.is_time_rewind:
		enemy_steering.nothing()
		#enemy_steering.pursuit(player.global_position, player.velocity, player.MAX_SPEED)
		#enemy_steering.arrival(player.global_position, player.get_attack_zone_radius())
		enemy_steering.seek(player.global_position)
		#enemy_steering.wander()
		#enemy_steering.flee(player.global_position)	
		#enemy_steering.evade(player.global_position, player.velocity, player.MAX_SPEED)
		enemy_steering.avoidance(ray_cast_center, ray_cast_left, ray_cast_right)
		enemy_steering.steer()
		sprite.rotation = desired_velocity.angle() + deg2rad(-90)
		collision.rotation = desired_velocity.angle() + deg2rad(-90)
		wander_offset.position = desired_velocity.normalized() * 60
