extends Area2D
class_name FloorSwitch

@export var tethered_object = Node
@export var tethered_object_secondary: Node = null

@export var wall_switch = false
var wall_switch_ready = false


# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
    if wall_switch:	
        if wall_switch_ready:
            if Input.is_action_pressed("grab"):
                activate_tethered_object()


func _on_body_entered(body: Node2D) -> void:
    if wall_switch:	
        wall_switch_ready = true
    else:
        activate_tethered_object()

func _on_body_exited(body: Node2D) -> void:
    if wall_switch:	
        wall_switch_ready = false
    else:
        if not get_overlapping_bodies():
            deactivate_tethered_object()

    
func activate_tethered_object():
    if tethered_object:
        tethered_object.activate()
        if tethered_object_secondary:
            tethered_object_secondary.disable()
    
func deactivate_tethered_object():
    if tethered_object:
        tethered_object.deactivate()
        if tethered_object_secondary:
            tethered_object_secondary.deactivate()
    
