extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
const PLOT = preload("res://Plants/plot.tscn")
const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
const OVERRIPE_PEPPER_PRODUCE = preload("res://Plants/pepper_overripe_produce.tscn")
const PEPPER_REMOVED_PARTICLES = preload("res://Plants/pepper_removed_particles.tscn")


var growth_state:=0
var state_name:= "Seed"
var action_name:String

## For now, I got rid of the picked bool concept.  When the plant is picked, it
## just jumps ahead to the senescent phase.  This is to make the plant die in a more
## timely fashion if you pick early.
#var picked:= false


func _ready() -> void:
    var theClock = get_node("/root/World/Clock")
    theClock.time_has_elapsed.connect(_time_elapsed)
    sprite_2d.frame = 0


func _time_elapsed():
    growth_step()
    if state_name == "Ripe": #or "Overripe":
        #print("Pepper Plant is " + str(state_name))
        #print("Rolling to spawn crow.")
        attempt_spawn_crow()


func growth_step():
    growth_state += 1
    update_growth_state()


## Handle Growth Process of plant in steps.  Can set up states farther appart in order to make a 
##state last a differing duration.
func update_growth_state():
    match growth_state:
        1,2,3:
            state_name= "Sprouting"
            action_name= ""
            sprite_2d.frame = 1
        4,5,6:
            state_name= "Young"
            action_name= ""
            sprite_2d.frame = 2
        7,8,9:
            state_name= "Maturing"
            action_name= ""
            sprite_2d.frame = 3
        10,11,12:
            state_name= "Mature"
            action_name= ""
            sprite_2d.frame = 4
        13,14,15:
            state_name= "Flowering"
            action_name= ""
            sprite_2d.frame = 5
        16,17,18:
            state_name= "Ripening"
            action_name= ""
            sprite_2d.frame = 6
        19,20,21,22,23,24,25,26,27,28,29,30:
            state_name="Ripe"
            action_name= "Pick"
            sprite_2d.frame = 7
            #if picked:
                #state_name = "picked"
                #sprite_2d.frame = 4
            #else:
                #state_name="ripe"
                #sprite_2d.frame = 7
        31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49:
            state_name = "Overripe"
            action_name= "Pick"
            sprite_2d.frame = 8
            #if picked:
                #state_name = "senescent"
                #sprite_2d.frame = 9
            #else:
                #state_name = "overripe"
                #sprite_2d.frame = 8
        50,51,52,53,54,55:
            state_name = "Dying"
            action_name= ""
            sprite_2d.frame = 9
        56, _:
            state_name = "Dead"
            action_name= "Remove"
            sprite_2d.frame = 10
    #print(state_name)


func get_info() -> Dictionary:
    var use_info = {}
    use_info.title = str(state_name) + " Pepper Plant"
    if action_name:
        use_info.action = action_name
    return use_info


func use() -> bool:
    match state_name:
        "Ripe":
            ## Pick Ripe Fruit
            spawn_produce(false,randi_range(1,3))
            growth_state = 50
            update_growth_state()
            ## Manually setting growth frame to handle corner case.
            sprite_2d.frame = 4
            return true
        
        "Overripe":
            ## Pick Overripe Fruit
            spawn_produce(true,randi_range(2,1))
            growth_state = 50
            update_growth_state()
            return true
        
        "Dead":
            ## Remove Dead Plant
            die()
            return true
        
        _:
            return false


func spawn_produce(is_overripe,quantity:= 1):
    for an_item in quantity:
        var new_produce 
        if is_overripe:
            new_produce = OVERRIPE_PEPPER_PRODUCE.instantiate()
        else:
            new_produce = PEPPER_PRODUCE.instantiate()
        new_produce.global_position = global_position
        new_produce.global_position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
        get_tree().get_current_scene().call_deferred("add_child", new_produce)
        await get_tree().create_timer(0.2).timeout


func die():
    ## Spawn Removal Effect
    var new_effect = PEPPER_REMOVED_PARTICLES.instantiate()
    new_effect.global_position = global_position
    get_tree().get_current_scene().call_deferred("add_child", new_effect)
    
    ## Spawn in Empty Plot
    var new_plot = PLOT.instantiate()
    new_plot.global_position = global_position
    get_tree().get_current_scene().call_deferred("add_child", new_plot)
    
    queue_free()


## Crow Spawning System ##
####################################################################################################
@export var crow_spawn_chance:= 40
const CROW = preload("res://Pests/crow.tscn")

func attempt_spawn_crow():
    if crow_spawn_chance == 0:
        return
    if randi_range(1,crow_spawn_chance) > 1:
        return
    print("Spawning Crow")
    var new_crow = CROW.instantiate()
    new_crow.global_position.x = global_position.x + (float(randi_range(0,2)*2-1) * randf_range(200,800))
    new_crow.global_position.y = global_position.y + randf_range(-1200,-1400)
    new_crow.destination = Vector2(
        global_position.x + randf_range(-20,20), 
        global_position.y + randf_range(1,15))
    get_tree().get_current_scene().call_deferred("add_child", new_crow)
