extends Node2D

var targets:Array

func _ready() -> void:
	targets = get_children()

func attack():
	for a_target in targets:
		a_target.attack()

func enable():
	for a_target in targets:
		a_target.call_deferred("set_enabled", false)
	visible = true

func disable():
	for a_target in targets:
		a_target.call_deferred("set_enabled", true)
	visible = false
