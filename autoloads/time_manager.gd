extends Node

var time_flow: float
var time_slow_mode: float = 3.0
var time_normal_mode: float = 1.0
var is_time_rewind: bool = false
var rewind_timer: Timer

signal rewind_started()
signal rewind_stopped()
	
func _ready():
	time_flow = time_normal_mode	

func slow_mode() -> void:
	time_flow = time_slow_mode
	
func normal_mode() -> void:
	time_flow = time_normal_mode
	
func adjust_speed(_speed: float) -> float:
	return _speed / time_flow
	
func rewind() -> void:
	emit_signal("rewind_started")
	is_time_rewind = true
	
func forward() -> void:
	emit_signal("rewind_stopped")
	is_time_rewind = false