extends Sprite

onready var shoot_timer = $ShootTimer
onready var bullet : PackedScene = preload("res://core/weapons/bullets/BaseBullet.tscn")
var parent
var bullet_offset = 5
	
func _process(delta: float) -> void:	
	
	look_at(ReferenceManager.crosshair.global_position)	
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if shoot_timer.time_left == 0:
			shoot_timer.start()
			
	if Input.is_action_just_released("left_button"):
		shoot_timer.stop()	


func shoot() -> void:
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated($Pivot/Muzzle.global_rotation + deg2rad(90))
	new_bullet.shoot($Pivot/Muzzle.global_position, direction)	
	new_bullet.global_scale = global_scale
	ReferenceManager.weapon_container.add_weapon(new_bullet)

func _on_ShootTimer_timeout() -> void:
	shoot()
