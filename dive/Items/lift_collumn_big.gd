extends LiftCollumnSmall

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("start_float"):
		body.start_float()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("stop_float"):
		body.stop_float()

# Override from base class to change back to lift_collumn_small.
func activate():
	print("activated")

func deactivate():
	print("deactivated")
