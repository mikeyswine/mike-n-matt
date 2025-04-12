extends StaticBody2D

@onready var spawn_point: Marker2D = $SpawnPoint
@export var spawn_chance:int = 20

const COIN = preload("res://Plants/coin.tscn")

const CUSTOMER_0 = preload("res://Map/Customers/customer_0.tscn")
const CUSTOMER_1 = preload("res://Map/Customers/customer_1.tscn")
const CUSTOMER_2 = preload("res://Map/Customers/customer_2.tscn")
const CUSTOMER_K = preload("res://Map/Customers/customer_k.tscn")

func _ready() -> void:
    var theClock = get_node("/root/World/Clock")
    theClock.time_has_elapsed.connect(_time_elapsed)


func buy():
    var new_coin = COIN.instantiate()
    new_coin.global_position = global_position
    get_tree().get_current_scene().call_deferred("add_child", new_coin)



func spawn_customer_roll():
    if randi_range(1,spawn_chance) > 1:
        return
    
    var character_roll = randi_range(0,100)
    var character_to_spawn
    if character_roll <=50:
        character_to_spawn = CUSTOMER_0.instantiate()
    elif character_roll <=80:
        character_to_spawn = CUSTOMER_1.instantiate()
    elif character_roll <=98:
        character_to_spawn = CUSTOMER_2.instantiate()
    else:
        character_to_spawn = CUSTOMER_K.instantiate()
    print("Spawning Customer")
    character_to_spawn.position = spawn_point.position
    character_to_spawn.position.y -= randf_range(0.0,100.0)
    #get_tree().get_current_scene().
    call_deferred("add_child", character_to_spawn)


func _time_elapsed():
    spawn_customer_roll()
