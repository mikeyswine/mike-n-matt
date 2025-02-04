extends Area2D

#@export var dmg: int = 1

func _on_body_entered(body: Node2D) -> void:
	attempt_damage(body)


func _on_area_entered(area: Area2D) -> void:
	attempt_damage(area)

func attempt_damage(body):
	print("Hitbox Entered")
	if body.has_method("take_damage"):
		print("Attempting damage")
		body.take_damage()
