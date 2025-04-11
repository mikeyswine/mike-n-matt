extends Area2D

@onready var hilight: Sprite2D = $Hilight

const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
@export var produce_type: String = 'NothingBerry'
@export var produce_overripe: bool = false
var produce_scale: float = 0.4
var produce_max_offset_x: float = 20
var produce_max_offset_y: float = 10
var produce_rotation_offset: float = 6.283 # 6.283 radians is ~360 degrees
var storehouse: Area2D
var selected:bool = false
var produce_count:= 0

func _ready() -> void:
	storehouse = get_parent()


func add_produce(is_overripe=false, quantity=1) -> void:
	produce_count += 1
	if produce_type == 'Pepper':
		var new_produce = PEPPER_PRODUCE.instantiate()
		new_produce.for_basket = true
		new_produce.overripe = is_overripe
		#new_produce.scale = Vector2(produce_scale, produce_scale)
		#new_produce.global_position = global_position
		new_produce.position.x += randf_range(-produce_max_offset_x,produce_max_offset_x)
		new_produce.position.y += randf_range(-produce_max_offset_y,0.0)
		new_produce.rotate(randf_range(0,produce_rotation_offset))
		call_deferred("add_child", new_produce)
		##new_produce.top_level = true  ## This is gonna cause problems with the player walking over them.

func get_info():
	##TODO if produce_count == 0, handle buy more of this produce
	var info:= {}
	info.title = str(produce_type) + " Basket"
	if produce_overripe:
		info.title = "Overripe " + info.title
	if !selected:
		info.action = "Select"
	return info

func use():
	if produce_count >0:
		select()
		return true
	return false

func select():
	storehouse.select_basket(produce_type,produce_overripe)
	hilight.visible = true
	selected = true

func deselect():
	hilight.visible = false
	selected = false
