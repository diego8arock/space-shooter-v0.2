extends Node

var time_flow: float
var time_slow_mode: float = 3.0
var time_normal_mode: float = 1.0

func _ready():
	time_flow = time_normal_mode

func slow_mode() -> void:
	time_flow = time_slow_mode
	
func normal_mode() -> void:
	time_flow = time_normal_mode
	
func adjust_speed(_speed: float) -> float:
	return _speed / time_flow