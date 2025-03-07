extends Area2D

@export var tethered_object = Node
@export var tethered_object_secondary = Node




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	activate_tethered_object()
	if tethered_object_secondary:
		tethered_object_secondary.disable()


func _on_body_exited(body: Node2D) -> void:
	if not get_overlapping_bodies():
		deactivate_tethered_object()
		if tethered_object_secondary:
			tethered_object_secondary.deactivate()
	
	
func activate_tethered_object():
	if tethered_object:
		tethered_object.activate()
	
func deactivate_tethered_object():
	if tethered_object:
		tethered_object.deactivate()
	
