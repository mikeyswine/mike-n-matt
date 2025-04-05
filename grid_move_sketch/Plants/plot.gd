extends Area2D

var PEPPER_PLANT: PackedScene

func _ready() -> void:
	PEPPER_PLANT = load("res://Plants/pepper_plant.tscn")

func use():
	print("attempting to plant a pepper plant")
	var new_plant = PEPPER_PLANT.instantiate()
	new_plant.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_plant)
	queue_free()
