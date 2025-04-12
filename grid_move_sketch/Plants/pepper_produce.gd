extends CharacterBody2D

var speed:= 300.0
var accel:= 200.0
var produce_type:= "Pepper"
var overripe:= false
var for_basket:= false

func _ready() -> void:
    if not for_basket:
        var store_house = get_node("/root/World/StoreHouse")
        rotation = get_angle_to(store_house.global_position)
    if overripe:
        $Sprite2D.frame = 1

func _physics_process(delta: float) -> void:
    if not for_basket:
        speed += accel * delta
        velocity = Vector2(speed*delta,0.0).rotated(rotation)
        var collision = move_and_collide(velocity)

func get_stored():
    queue_free()
