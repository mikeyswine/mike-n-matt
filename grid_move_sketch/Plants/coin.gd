extends CharacterBody2D

var speed:= 50.0
var accel:= 30.0
var direction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var store_house = get_node("/root/World/StoreHouse")
    direction = global_position.direction_to(store_house.global_position)
    
    
func _physics_process(delta: float) -> void:
    speed += accel * delta
    velocity = direction * speed * delta
    var collision = move_and_collide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
    
func get_stored():
    queue_free()
