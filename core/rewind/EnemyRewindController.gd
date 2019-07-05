extends Node2D
class_name EnemyRewindController

onready var enemy: Enemy = get_parent()
onready var debug: = $SimpleDebug

var rewind_position = []
var rewind_rotation = []
var rewind_max_time = 5

onready var rewind_timer = $RewindTimer

func _ready() -> void:
	
	TimeManager.connect("rewind_started", self, "on_TimeManager_rewind_started")
	TimeManager.connect("rewind_stopped", self, "on_TimeManager_rewind_stopped")
	debug.add_label("rewin_time_left")
	debug.add_label("rewind_position")
	debug.add_label("rewind_rotation")

func _process(delta: float) -> void:
	
	debug.update_label("rewin_time_left" , TimeManager.rewind_timer.time_left)
	debug.update_label("rewind_position" , rewind_position.size())
	debug.update_label("rewind_rotation" , rewind_rotation.size())
	
	if not TimeManager.is_time_rewind:
		add_rewind_position()
#		add_rewind_rotation()
	else:
		enemy.global_position = rewind_position.pop_front()
#		var old_rotation = rewind_rotation.pop_front()
#		parent.ship_sprite.global_rotation = old_rotation
#		parent.collision.global_rotation = old_rotation
	
func add_rewind_position() -> void:
	
	rewind_position.push_front(enemy.global_position)	
	if TimeManager.rewind_timer.time_left == 0:
		rewind_position.pop_back()

func add_rewind_rotation() -> void:
	
	rewind_rotation.push_front(enemy.ship_sprite.global_rotation)	
	if TimeManager.rewind_timer.time_left == 0:
		rewind_rotation.pop_back()

func on_TimeManager_rewind_started() -> void:
	pass
	
func on_TimeManager_rewind_stopped() -> void:
	rewind_position.clear()
	pass