@tool
extends Node2D

@onready var mine: CharacterBody2D = $Mine

@export var height:float = 30.0


func _ready() -> void:
	mine.position.y = -height

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		mine.position.y = -height
