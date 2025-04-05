extends Area2D

enum {
	ARRIVING,
	WAITING,
	PECKING,
	FLEEING
}

var state = ARRIVING
var destination:= Vector2(100.0,0.0)
var speed = 150.0

func _ready() -> void:
	$AnimationPlayer.play("fly")

func _physics_process(delta: float) -> void:
	match state:
		ARRIVING:
			global_position = global_position.move_toward(destination,speed*delta)
			if global_position == destination:
				state = WAITING
				$AnimationPlayer.play("idle")
		WAITING:
			pass
