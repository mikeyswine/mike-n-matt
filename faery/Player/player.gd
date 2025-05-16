extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):# and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimationPlayer.play("flap")
		%CPUParticles2D.emitting = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			$AnimationPlayer.play("skate")
		if direction > 0.0:
			$Body.scale.x = 1.0
		elif direction < 0.0:
			$Body.scale.x = -1.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
