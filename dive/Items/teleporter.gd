extends Area2D

@export var destination_level = preload("res://Levels/mine_level.tscn")

func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_packed(destination_level)
	#get_tree().call_deferred("change_scene_to_packed", destination_level)
