@tool
## This sets up file to be run in editor
extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var height := 80 : set = set_height

## Custom Setter for height variable.
func set_height(height_nuevo):
	height = height_nuevo
	## This causes code inside to run in editor!
	## We also do it in a custom setter here, so the collision shape adjusts when you change the export var.
	if Engine.is_editor_hint():
			update_collider()
	update_collider()


func _ready() -> void:
	## This causes code inside to run in editor!
	## I run it once in ready so that the height is initially adjusted in the editor
	## The standard approach is to toss it in _process(), but then it'll execute every step forever, needlessly
	if Engine.is_editor_hint():
			update_collider()


## Adjust physical collider according to the height variable.
func update_collider():
	collision_shape_2d.shape.size.y = height
	collision_shape_2d.position.y = -height/2


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("start_float"):
		body.start_float()


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("stop_float"):
		body.stop_float()
