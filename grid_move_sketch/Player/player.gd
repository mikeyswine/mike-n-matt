extends Area2D

## Movement Components
@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast
@onready var up_raycast: RayCast2D = $UpRaycast
@onready var down_raycast: RayCast2D = $DownRaycast
@onready var current_location_ray_cast: RayCast2D = $CurrentLocationRayCast

## Use Components
@onready var use_raycast: RayCast2D = $UseRaycast
@onready var popup: VBoxContainer = %Popup
@onready var title: Label = %title
@onready var action_container: HBoxContainer = %ActionContainer
@onready var action: Label = %action



@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: Area2D = $"."

@export var move_time:float= 0.3

signal time_elapsed

enum{
    UP,
    DOWN,
    LEFT,
    RIGHT
}

enum{
    IDLE,
    MOVING,
}

var state = IDLE

## Store current location just in case we ever need to reference it.
var current_location: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    current_location = current_location_ray_cast.get_collider()
    get_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    match state:
        IDLE:
            handle_move_input()
            
            ## Handle use input
            if Input.is_action_just_pressed("action"):
                use()
        
        MOVING:
            ## Allows moving when character is already in motion.
            ## makes it feel more responsive, but allows spamming moves.
            ## Comment out to prevent player from moving until they arrive.
            handle_move_input()
            
            ## Handle use input
            if Input.is_action_just_pressed("action"):
                use()
            
            ## Check if move is complete & transition to idle state.
            if global_position == current_location.global_position:
                animation_player.play("idle")
                state = IDLE
                get_info()
                ## Prompt Clock to advance.  
                ## Placed here so that spamming move doesn't elapse time. Only when player arrives.
                time_elapsed.emit()



func handle_move_input():
    if Input.is_action_just_pressed("up"):
        attempt_move(UP)
    if Input.is_action_just_pressed("down"):
        attempt_move(DOWN)
    if Input.is_action_just_pressed("left"):
        attempt_move(LEFT)
    if Input.is_action_just_pressed("right"):
        attempt_move(RIGHT)

func attempt_move(new_direction):
    clear_get_info()
    ## Parse direction for appropriate raycast
    var attempt_raycast:Node2D
    match new_direction:
        UP:
            attempt_raycast = up_raycast
        DOWN:
            attempt_raycast = down_raycast
        LEFT:
            attempt_raycast = left_raycast
        RIGHT:
            attempt_raycast = right_raycast
    var move_target = attempt_raycast.get_collider()
    
    ## Check if terrain exists in desired direction.
    if !move_target: 
        print("no terrain")
        return false
    
    ## Removing Occupied concept b/c we proly won't use it for this jam.
    ## Check if terrain is already occupied
    #if move_target.occupied:
        #print("terrain occupied")
        #return false
    
    ## Move player to new location
    var move_tween = get_tree().create_tween()
    move_tween.set_ease(Tween.EASE_IN_OUT)
    move_tween.set_trans(Tween.TRANS_EXPO)
    move_tween.tween_property(self,"global_position",move_target.global_position,move_time)
    
    ## Removing Occupied concept b/c we proly won't use it for this jam.
    #if current_location:
        #current_location.occupied = null
    #move_target.occupied = self
    
    ## Handle other move business
    state = MOVING
    animation_player.play("move")
    current_location = move_target
    #time_elapsed.emit()
    return true


func get_info():
    var useable = use_raycast.get_collider()
    if !useable or !useable.has_method("get_info"): 
        clear_get_info()
        return
    
    var new_info = useable.get_info()
    popup.visible = true
    title.text = new_info.title
    if new_info.has("action"):
        action_container.visible = true
        action.text = new_info.action
    else:
        action_container.visible = false
        action.text = ""

func clear_get_info():
    title.text = ""
    action.text = ""
    popup.visible = false

func use():
    var useable = use_raycast.get_collider()
    print(useable)
    ## Check if there's a useable under the player
    if !useable: 
        print("No Useable Found")
        $UI_No.play()
        return
    if useable.has_method("use"): 
        print("Attempting to use")
        if useable.use():
            useable = null
        else:
            $UI_No.play()
            ## expects use() to return true to indicate if an action is taken.
            ## if no action is taken, plays a sound to indicate no action available.
    useable = null
    get_info()
    $UseInfoTimer.start()

func _on_use_info_timer_timeout() -> void:
    get_info()
