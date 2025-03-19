extends Box
#extends CharacterBody2D


#const SINK_RATE = 10
#
#func _physics_process(delta: float) -> void:
    ## Add the gravity.
    #if not is_on_floor():
        #velocity += Vector2(0,SINK_RATE) * delta 
        #move_and_slide()

func _on_left_side_body_entered(body: Node2D) -> void:
    if body_is_player(body):
        movable = true
    

func _on_left_side_body_exited(body: Node2D) -> void:
    if body_is_player(body):
        movable = false
        direction = 0


func _on_right_side_body_entered(body: Node2D) -> void:
    if body_is_player(body):
        movable = true


func _on_right_side_body_exited(body: Node2D) -> void:
    if body_is_player(body):
        movable = false
        direction = 0
