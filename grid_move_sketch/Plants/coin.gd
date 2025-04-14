extends CharacterBody2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
const COIN_1 = preload("res://Plants/sounds/coin.2.ogg")
const COIN_2 = preload("res://Plants/sounds/coin.3.ogg")
const COIN_3 = preload("res://Plants/sounds/coin.11.ogg")

var speed:= 100.0
var accel:= 50.0
var direction
var produce_type:= "gold"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var store_house = get_node("/root/World/StoreHouse")
    direction = global_position.direction_to(store_house.global_position)
    match randi_range(1,3):
        1:
            audio_stream_player.stream = COIN_1
        2:
            audio_stream_player.stream = COIN_2
        3:
            audio_stream_player.stream = COIN_3
    audio_stream_player.play()
    
func _physics_process(delta: float) -> void:
    speed += accel * delta
    velocity = direction * speed * delta
    var collision = move_and_collide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
    
func get_stored():
    queue_free()
