extends Node2D
class_name PlayerRewindController

onready var parent: Player = get_parent()
onready var debug: = $SimpleDebug

var rewind_position = []
var rewind_rotation = []
var rewind_max_time = 5

onready var rewind_timer = $RewindTimer

func _ready() -> void:
	
	TimeManager.rewind_timer = rewind_timer
	rewind_timer.start(rewind_max_time)
	debug.add_label("rewin_time_left")
	debug.add_label("rewind_position")
	debug.add_label("rewind_rotation")

func _process(delta: float) -> void:
	
	debug.update_label("rewin_time_left" , TimeManager.rewind_timer.time_left)
	debug.update_label("rewind_position" , rewind_position.size())
	debug.update_label("rewind_rotation" , rewind_rotation.size())
	
	if not TimeManager.is_time_rewind:
		add_rewind_position()
		add_rewind_rotation()
	else:
		parent.global_position = rewind_position.pop_front()
		var old_rotation = rewind_rotation.pop_front()
		parent.ship_sprite.global_rotation = old_rotation
		parent.collision.global_rotation = old_rotation
		if rewind_position.size() == 0:
			rewind_timer.start(rewind_max_time)
			parent.time_mode = parent.TIME_MODE.NORMAL
			TimeManager.forward()
	
func add_rewind_position() -> void:
	
	rewind_position.push_front(parent.global_position)	
	if TimeManager.rewind_timer.time_left == 0:
		rewind_position.pop_back()

func add_rewind_rotation() -> void:
	
	rewind_rotation.push_front(parent.ship_sprite.global_rotation)	
	if TimeManager.rewind_timer.time_left == 0:
		rewind_rotation.pop_back()
		
