extends CharacterBody2D

@export var speed:float = 20.0

func _ready():
	rotation_degrees += randf_range(-15,15)
	velocity = Vector2(0,-speed).rotated(rotation)
	$PickupArea.monitoring = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += 10.0 * delta
		#if velocity.y > 0.0:
			#$PickupArea.monitoring = true
		move_and_slide()


func _on_pickup_area_body_entered(body: Node2D) -> void:
	body.increment_coins()
	queue_free()


func _on_timer_timeout() -> void:
	$PickupArea.monitoring = true
