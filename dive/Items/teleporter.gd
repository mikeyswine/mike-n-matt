extends Area2D

#@export var destination_level := preload("res://Levels/world.tscn")
@export var destination_level_file = "res://Levels/world.tscn"
@export var custom_start_position:Vector2


func _on_body_entered(body: Node2D) -> void:
    #get_tree().change_scene_to_packed(destination_level)
    if custom_start_position:
        LevelSingleton.custom_start_position = custom_start_position
        
    #get_tree().call_deferred("change_scene_to_packed", destination_level)
    get_tree().call_deferred("change_scene_to_file",destination_level_file)
