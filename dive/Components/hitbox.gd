extends Area2D

#@export var dmg: int = 1

func _on_body_entered(body: Node2D) -> void:
	attempt_damage(body)


func _on_area_entered(area: Area2D) -> void:
	attempt_damage(area)

func attempt_damage(body):
	if body.has_method("take_damage"):
		body.take_damage()
	if body.has_method("die"):
		body.die()
