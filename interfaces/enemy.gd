extends Area2D
class_name Enemy, "res://interfaces/enemy.gd"

var angle_change: float
var desired_velocity: Vector2
var mass: float
var max_force: float
var max_see_ahead: float
var max_velocity: float
var steering: Vector2
var velocity: Vector2
var wander_angle: float
var wander_offset: CollisionShape2D
