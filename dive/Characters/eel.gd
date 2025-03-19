extends Sprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var target:CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	target = body
	if body.has_method("take_damage"): body.take_damage()
	animated_sprite_2d.play("strike")


func _on_animated_sprite_2d_animation_finished() -> void:
	if target:
		if target.has_method("take_damage"):
			target.take_damage()
			animated_sprite_2d.play("strike")
			return
	animated_sprite_2d.play("idle")


func _on_area_2d_body_exited(body: Node2D) -> void:
	target = null
