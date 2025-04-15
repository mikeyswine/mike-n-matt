extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D

enum {
    ARRIVING,
    WAITING,
    PECKING,
    FLEEING
}
var state = ARRIVING

@export var destination:= Vector2(500.0,0.0)
@export var wait_time_min:= 1
@export var wait_time_max:= 3
var wait_time:int

var speed = 200.0


func _ready() -> void:
    $AudioStreamPlayer.pitch_scale = randf_range(0.8,1.1)
    animation_player.play("fly")
    #set_deferred("monitoring", false)
    set_collision_mask_value(2,false)
    wait_time = randi_range(wait_time_min,wait_time_max)
    
    ## Connect Clock Signal
    var theClock = get_node("/root/World/Clock")
    theClock.time_has_elapsed.connect(_time_elapsed)
    handle_direction()
    top_level = true


func _physics_process(delta: float) -> void:
    match state:
        ARRIVING:
            global_position = global_position.move_toward(destination,speed*delta)
            if global_position == destination:
                state = WAITING
                top_level = false
                #set_deferred("monitoring", true)
                set_collision_mask_value(2,true)
                animation_player.play("idle")
        WAITING:
            pass
        PECKING:
            pass
        FLEEING:
            global_position = global_position.move_toward(destination,speed*delta)
            if global_position == destination:
                queue_free()


## Decrement counter during WAITING state
func _time_elapsed():
    if state == WAITING:
        wait_time -= 1
        if wait_time <= 0:
            state = PECKING
            animation_player.play("peck_prep")


## Player has entered crow's range
func _on_area_entered(area: Area2D) -> void:
    flee()

func pecking_done():
    var pecked_plant = ray_cast_2d.get_collider()
    ## TODO If we add plant health/variable harvest, this will turn into a damage loop instead of
    ## a simple request to die
    if pecked_plant:
        if pecked_plant.has_method("die"):
            pecked_plant.die()
    flee()

func flee():
    $AudioStreamPlayer.play()
    handle_direction()
    animation_player.play("fly")
    set_collision_mask_value(2,false)
    destination.x = randf_range(destination.x -1000.0, destination.x + 1000.0)
    destination.y = destination.y - 2000
    state = FLEEING
    top_level = true

func handle_direction():
    if destination > global_position:
        $Sprite2D.flip_h = false
    else:
        $Sprite2D.flip_h = true
