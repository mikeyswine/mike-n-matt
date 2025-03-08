extends Area2D

func _ready() -> void:
	if PlayerSingleton.has_anchor:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	PlayerSingleton.has_anchor = true
	set_deferred("monitoring", false)
	$AnimationPlayer.play("pickup")
