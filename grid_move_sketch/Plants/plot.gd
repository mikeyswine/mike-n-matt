extends Area2D

var title:= "Open Plot"
var action:= "Plant Peppers"

var PEPPER_PLANT: PackedScene
var storehouse: Area2D

func _ready() -> void:
	PEPPER_PLANT = load("res://Plants/pepper_plant.tscn")
	storehouse = get_node("/root/World/StoreHouse")

func use():
	##TODO Turn this into a request to plant to the store_house.
	print("attempting to plant a pepper plant")
	var new_plant = PEPPER_PLANT.instantiate()
	new_plant.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_plant)
	queue_free()
	return true

func get_info() -> Dictionary:
	##TODO Make this poll the store_house for this info, to find what's currently selected.
	var use_info = {}
	use_info.title = title
	if action:
		use_info.action = action
	return use_info
