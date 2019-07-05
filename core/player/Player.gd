extends KinematicBody2D
class_name Player, "res://core/player/Player.tscn"

var speed: float = 0.0
var speed_rate: float = 2.5
var direction: Vector2 = Vector2(1,0)
var velocity_rotation: float = 0.0
var velocity_rotation_speed: float = 3.0
var velocity: Vector2

const MAX_SPEED: float = 5.0
const MAX_SPEED_REVERSE: float = -5.0

var is_forward: bool = true
var is_reverse: bool = true

onready var debug = $SimpleDebug
onready var ship_sprite = $Sprite
onready var collision = $CollisionPolygon2D

onready var attack_zone = $AttackZone setget ,get_attack_zone_radius

enum TIME_MODE {NORMAL, SLOW, REWIND}
var time_mode = TIME_MODE.NORMAL

func _ready():	
	pass

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_up"):
		foward(delta)
		
	if Input.is_action_pressed("ui_down"):
		reverse(delta)
	
	if Input.is_action_pressed("ui_right"):
		turning_right(delta)	
		
	if Input.is_action_pressed("ui_left"):
		turning_left(delta)

func _physics_process(delta: float) -> void:	
	
	if not TimeManager.is_time_rewind:
		velocity = direction.normalized().rotated(velocity_rotation) * TimeManager.adjust_speed(speed)
		ship_sprite.global_rotation = velocity_rotation
		collision.global_rotation = velocity_rotation 
		move_and_collide(velocity)
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.is_action_pressed("button_right") and time_mode != TIME_MODE.REWIND:
			match time_mode:
				TIME_MODE.NORMAL:
					TimeManager.slow_mode()
					time_mode = TIME_MODE.SLOW
				TIME_MODE.SLOW:
					TimeManager.normal_mode()
					time_mode = TIME_MODE.NORMAL
					
	if event is InputEventKey:
		if event.is_action_pressed("rewind"):
			time_mode = TIME_MODE.REWIND
			TimeManager.rewind()			
	
func foward(_delta: float) -> void:
	
	speed += speed_rate * _delta
	speed = clamp(speed, MAX_SPEED_REVERSE, MAX_SPEED)
	is_forward = true
	is_reverse = false
	
func reverse(_delta: float) -> void:
	
	speed -= speed_rate * _delta
	speed = clamp(speed, MAX_SPEED_REVERSE, MAX_SPEED)
	is_forward = false
	is_reverse = true
	
func turning_right(_delta: float) -> void:
	
	if is_forward:
		turning(_delta, 1)
	if is_reverse:
		turning(_delta, -1)
	
func turning_left(_delta: float) -> void:
	
	if is_forward:
		turning(_delta, -1)
	if is_reverse:	
		turning(_delta, 1)
		
func turning(_delta: float, _direction: int) -> void:
	
	velocity_rotation += TimeManager.adjust_speed(velocity_rotation_speed) * _delta * _direction
	
func get_attack_zone_radius() -> float:
	
	return (attack_zone.shape as CircleShape2D).radius
