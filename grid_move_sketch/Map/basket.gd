extends Area2D

const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
@export var produce_type: String = 'NothingBerry'
@export var produce_overripe: bool = false

func _ready() -> void:
    pass
    
func add_produce(is_overripe=false, quantity=1) -> void:
    print('produce added')
    if produce_type == 'PepperProduce':
        var new_produce = PEPPER_PRODUCE.instantiate()
        new_produce.for_basket = true
        new_produce.overripe = is_overripe
        new_produce.global_position = global_position
        #get_tree().get_current_scene().call_deferred("add_child", new_produce)
        call_deferred("add_child", new_produce)
        
    
    
    
