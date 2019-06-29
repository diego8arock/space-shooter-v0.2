extends Area2D

export var speed : float = 200.0
export var speed_multiplier : int = 5

var velocity = Vector2()

func _process(delta):
	global_position += velocity * delta

func shoot(_position: Vector2, _rotation: Vector2):
	global_position = _position
	global_rotation = _rotation.angle()
	velocity = _rotation * TimeManager.adjust_speed(speed) * speed_multiplier

func _on_VisibilityEnabler2D_screen_exited():
	destroy_bullet()

func _on_TimeToLive_timeout():
	destroy_bullet()

func destroy_bullet() -> void:
	call_deferred("free")

