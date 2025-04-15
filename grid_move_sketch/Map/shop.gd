extends Area2D

@onready var spawn_point: Marker2D = $SpawnPoint
@onready var counter: Node2D = $Counter


@export var spawn_chance:int = 20

const COIN = preload("res://Plants/coin.tscn")

const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
const OVERRIPE_PEPPER_PRODUCE = preload("res://Plants/pepper_overripe_produce.tscn")
const PUMPKIN_PRODUCE = preload("res://Plants/pumpkin_produce.tscn")
const PEPPER_HOOCH_PRODUCE = preload("res://Plants/pepper_hooch_produce.tscn")


const CUSTOMER_0 = preload("res://Map/Customers/customer_0.tscn")
const CUSTOMER_1 = preload("res://Map/Customers/customer_1.tscn")
const CUSTOMER_2 = preload("res://Map/Customers/customer_2.tscn")
const CUSTOMER_K = preload("res://Map/Customers/customer_k.tscn")


@export var purchase_price:= 10
var operating:= false
var storehouse

var stocked_product:Array = []

func _ready() -> void:
    var theClock = get_node("/root/World/Clock")
    theClock.time_has_elapsed.connect(_time_elapsed)
    storehouse = get_node("/root/World/StoreHouse")
    $OpenSign.visible = false

func get_info():
    ## Handle Opening Shop
    if !operating:
        var purchase_use_info = {}
        purchase_use_info.title = "Open FarmStand: " + str(purchase_price) + " Ripe Peppers"
        if storehouse.produce.Pepper > purchase_price:
            purchase_use_info.action = "Purchase"
        return purchase_use_info
    
    ## Handle Operational Shop
    var shop_info = {}
    var current_crop = storehouse.request_info()
    if current_crop == "":
        shop_info.title = "Not Enough Selected Produce"
        return shop_info
    shop_info.title = "Stock Farmstand with 1: " + storehouse.request_info()
    shop_info.action = "stock"
    return shop_info


func use() -> bool:
    ## Handle Buying FarmStand
    if !operating:
        ## If Player Has Enough Produce
        if storehouse.produce.Pepper > purchase_price:
            ## Remove that much produce from storehouse, and add it to the farmstand
            for purchase in purchase_price:
                storehouse.request_produce("Pepper")
                stock_produce("Pepper")
            ## Make storehouse operational.
            operating = true
            $BuySign.visible = false
            $OpenSign.visible = true
            return true
        return false
    
    ## Handle Stocking Shop
    ## TODO Either Don't allow player to stock the last pepper, or add in ability to buy a pepper with gold.
    var produce_to_stock = storehouse.request_produce()
    if produce_to_stock:
            stock_produce(produce_to_stock)
            return true
    return false


func stock_produce(produce_type:String):
    var new_produce
    match produce_type:
        'Pepper':
            new_produce = PEPPER_PRODUCE.instantiate()
            new_produce.rotate(randf_range(-PI,-PI/2))
        'Overripe Pepper':
            new_produce = OVERRIPE_PEPPER_PRODUCE.instantiate()
            new_produce.rotate(randf_range(-PI,-PI/2))
        'Pepper Schnapps':
            new_produce = PEPPER_HOOCH_PRODUCE.instantiate()
        'Pumpkin':
            new_produce = PUMPKIN_PRODUCE.instantiate()
            new_produce.rotate(randf_range(-PI,-PI/2))
    new_produce.for_basket = true
    new_produce.position.x += randf_range(-20,20)
    new_produce.position.y += randf_range(-40,40)
    
    counter.call_deferred("add_child", new_produce)


func buy(buyer_location):
    ## Pop a random child off of the Counter
    var child_number = counter.get_child_count()
    if child_number > 0:
        var purchase = counter.get_child(randi_range(0,child_number-1))
        match purchase.produce_type:
            "Pepper":
                spawn_coin()
                spawn_coin()
            "Overripe Pepper":
                spawn_coin()
            "Pepper Schnapps":
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
            "Pumpkin":
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                spawn_coin()
                
                
        purchase.queue_free()


func spawn_coin():
    var new_coin = COIN.instantiate()
    new_coin.global_position = counter.global_position
    new_coin.global_position+= Vector2(randf_range(-16.0,16.0),randf_range(-16.0,16.0))
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
    if operating:
        spawn_customer_roll()
