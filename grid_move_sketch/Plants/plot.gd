extends Area2D

var title:= "Open Plot"
var action:= ""

var PEPPER_PLANT: PackedScene
const PUMPKIN_PLANT = preload("res://Plants/pumpkin_plant.tscn")
var storehouse: Area2D

func _ready() -> void:
    PEPPER_PLANT = load("res://Plants/pepper_plant.tscn")
    storehouse = get_node("/root/World/StoreHouse")

func use():
    var new_plant
    match storehouse.request_produce():
        "Pepper","Overripe Pepper":
            new_plant = PEPPER_PLANT.instantiate()
        "Pumpkin":
            new_plant = PUMPKIN_PLANT.instantiate()
        _:
            return false
    new_plant.global_position = global_position
    get_tree().get_current_scene().call_deferred("add_child", new_plant)
    queue_free()
    return true


func get_info() -> Dictionary:
    var selected_plant_name = storehouse.request_info()
    if selected_plant_name:
        title = "Convert 1 " + selected_plant_name + " to seed"
        action = "Plant " + selected_plant_name.trim_prefix("Overripe ")
    else:
        title = "No Seed Selected"
        
    var use_info = {}
    use_info.title = title
    if action:
        use_info.action = action
    return use_info
