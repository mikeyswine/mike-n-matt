extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("start_float"):
		body.start_float()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("stop_float"):
		body.stop_float()
