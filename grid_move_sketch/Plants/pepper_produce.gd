extends CharacterBody2D

var speed:= 300.0
var accel:= 200.0
var produce_type:= "Pepper"
@export var for_basket:= false

func _ready() -> void:
    if not for_basket:
        var store_house = get_node("/root/World/StoreHouse")
        rotation = get_angle_to(store_house.get_basket(produce_type).global_position)
        $PickAudio.pitch_scale = randf_range(0.9,1.1)
        $PickAudio.play()
    else:
        $CollectAudio.play()
        set_collision_layer_value(4,false)

func _physics_process(delta: float) -> void:
    if not for_basket:
        speed += accel * delta
        velocity = Vector2(speed*delta,0.0).rotated(rotation)
        var collision = move_and_collide(velocity)
