class_name Box
extends CharacterBody2D

const SINK_RATE = 10
@export var move_speed:float = 2000
var movable = false
var direction = 0


func _physics_process(delta: float) -> void:
	if movable:	
		if Input.is_action_pressed("grab"):
			var direction := Input.get_axis("left", "right")
			velocity.x = direction*delta*move_speed
			move_and_slide()
	elif not is_on_floor():
		velocity += Vector2(0,SINK_RATE) * delta 
		move_and_slide()
	

func body_is_player(body: Node2D):
	if body.name == 'Player':
		return true
	else:
		return false


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
