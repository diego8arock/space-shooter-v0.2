extends Area2D
class_name Crosshair

func _ready():
	ReferenceManager.crosshair = self
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		global_position += event.relative
		
	
	