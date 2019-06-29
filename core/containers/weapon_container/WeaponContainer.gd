extends Node2D
class_name WeaponContainer

func _ready() -> void:
	ReferenceManager.weapon_container = self

func add_weapon(_weapon: Area2D) -> void:
	add_child(_weapon)
