extends Node

@onready var clock_label: Label = %ClockLabel

signal time_has_elapsed(new_time)

var time:int = 0


func _on_player_time_elapsed() -> void:
	time += 1
	clock_label.text = str(time)
	time_has_elapsed.emit(time)
