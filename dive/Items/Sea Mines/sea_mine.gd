@tool
extends Node2D

@onready var mine: CharacterBody2D = $Mine

@export var height:float = 30.0
@export var horrizontal_range:float = 4.0
@export var drift_speed:float = 0.03
@export var float_rate:float = 1.0
@export var randomize_home: bool = true
@export var randomize_speed: bool = true
@export var speed_rand_ammount: float = 0.01

var can_explode_by_switch = true

##TODO This is bugging out in editor;  seems like child isn't ready yet.  Figure out how to fix it.
## I thought children ready before parents normally?  Maybe call it in child's ready function,
## But that would also break if parent isn't ready?  Could handshake between them, but that sucks.
## tl;dr: google it.
func _ready() -> void:
	mine.position.y = -height
	mine.horrizontal_range = horrizontal_range
	mine.drift_speed = drift_speed
	print("Parent Setting Child Speed")
	mine.float_rate = float_rate
	mine.randomize_home = randomize_home
	mine.randomize_speed = randomize_speed
	mine.speed_rand_ammount = speed_rand_ammount

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		mine.position.y = -height
		%Line2D.set_point_position(1,mine.position)
		
func activate():
	if can_explode_by_switch:
		can_explode_by_switch = false
		mine.is_tethered = false
		mine.explode()
		
func deactivate():
	pass


#func _draw() -> void:
	#if Engine.is_editor_hint():
		#draw_line(
			#Vector2(mine.position.x + (horrizontal_range/2),mine.position.y),
			#Vector2(mine.position.x - (horrizontal_range/2), mine.position.y),
			#Color.WHITE, false)
