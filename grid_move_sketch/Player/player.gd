extends Area2D

@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast
@onready var up_raycast: RayCast2D = $UpRaycast
@onready var down_raycast: RayCast2D = $DownRaycast
@onready var current_location_ray_cast: RayCast2D = $CurrentLocationRayCast

@onready var use_raycast: RayCast2D = $UseRaycast

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var player: Area2D = $"."
@onready var popup: Label = $Popup

@export var move_time:float= 0.3

signal time_elapsed

enum{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var facing = UP

enum{
	IDLE,
	MOVING,
	USING
}

var state = IDLE

var current_location: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_location = current_location_ray_cast.get_collider()
	popup.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			if Input.is_action_just_pressed("action"):
				use()
			if Input.is_action_just_pressed("up"):
				attempt_move(UP)
			if Input.is_action_just_pressed("down"):
				attempt_move(DOWN)
			if Input.is_action_just_pressed("left"):
				attempt_move(LEFT)
			if Input.is_action_just_pressed("right"):
				attempt_move(RIGHT)
		MOVING:
			## Check for complete move
			if global_position == current_location.global_position:
				animation_player.play("idle")
				state = IDLE
				
			if Input.is_action_just_pressed("action"):
				use()
		USING:
			pass
		
		#if current_location:
			#if global_position == current_location.global_position:
				#get_info()


func attempt_move(new_direction):
	var attempt_raycast:Node2D
	facing = new_direction
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
	#print(move_target)
	if !move_target: 
		print("no terrain")
		return false
	if move_target.occupied:
		print("terrain occupied")
		return false
	#var move_location = move_target.global_position
	var move_tween = get_tree().create_tween()
	move_tween.set_ease(Tween.EASE_IN_OUT)
	move_tween.set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self,"global_position",move_target.global_position,move_time)
	
	#$Sprite2D.scale.y = 0.5
	#var height_tween = get_tree().create_tween()
	#height_tween.set_ease(Tween.EASE_IN)
	#height_tween.set_trans(Tween.TRANS_BACK)
	#height_tween.tween_property($Sprite2D,"scale:y",0.6,move_time)
	
	state = MOVING
	animation_player.play("move")
	
	if current_location:
		current_location.occupied = null
	move_target.occupied = self
	current_location = move_target
	time_elapsed.emit()
	return true

func get_info():
	#var useable = use_raycast.get_collider()
	##if !useable: 
		##popup.text = ""
		##return
	#if useable.has_method("get_info"):
		#popup.text = useable.get_description()
	pass

func use():
	var useable = use_raycast.get_collider()
	print(useable)
	if !useable: 
		print("No Useable Found")
		return
	if useable.has_method("use"): 
		useable.use()
		print("Attempting to use")
	useable = null
