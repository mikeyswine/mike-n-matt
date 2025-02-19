extends CharacterBody2D

const SINK_RATE = 10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0,SINK_RATE) * delta 

	move_and_slide()
