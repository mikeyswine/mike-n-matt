extends Area2D

var title := "Grass"
var action_name := "Cut"
var growth_counter:= 0
var alive:= true


func use():
    die()
    return true

func get_info() -> Dictionary:
    var use_info = {}
    use_info.title = title
    if action_name:
        use_info.action = action_name
    return use_info


const PLOT = preload("res://Plants/plot.tscn")
const GRASS_REMOVED_PARTICLES = preload("res://Plants/grass_removed_particles.tscn")

func die():
    ## Spawn Removal Effect
    var new_effect = GRASS_REMOVED_PARTICLES.instantiate()
    new_effect.global_position = global_position
    get_tree().get_current_scene().call_deferred("add_child", new_effect)
    
    ## Spawn in Empty Plot
    var new_plot = PLOT.instantiate()
    new_plot.global_position = global_position
    get_tree().get_current_scene().call_deferred("add_child", new_plot)
    
    queue_free()
