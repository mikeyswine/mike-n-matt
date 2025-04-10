extends Area2D

const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
@export var produce_type: String = 'NothingBerry'
@export var produce_overripe: bool = false
var produce_scale: float = 0.4
var produce_max_offset_x: float = 20
var produce_max_offset_y: float = 10
var produce_rotation_offset: float = 6.283 # 6.283 radians is ~360 degrees

func _ready() -> void:
    pass
    
func add_produce(is_overripe=false, quantity=1) -> void:
    if produce_type == 'PepperProduce':
        var new_produce = PEPPER_PRODUCE.instantiate()
        new_produce.for_basket = true
        new_produce.overripe = is_overripe
        new_produce.scale = Vector2(produce_scale, produce_scale)
        new_produce.global_position = global_position
        new_produce.position.x += randf_range(-produce_max_offset_x,produce_max_offset_x)
        new_produce.position.y += randf_range(-produce_max_offset_y,produce_max_offset_y)
        new_produce.rotate(randf_range(0,produce_rotation_offset))
        call_deferred("add_child", new_produce)
        new_produce.top_level = true
        
    
    
    
