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


#func _draw() -> void:
	#if Engine.is_editor_hint():
		#draw_line(
			#Vector2(mine.position.x + (horrizontal_range/2),mine.position.y),
			#Vector2(mine.position.x - (horrizontal_range/2), mine.position.y),
			#Color.WHITE, false)
