extends Area2D

@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast
@onready var up_raycast: RayCast2D = $UpRaycast
@onready var down_raycast: RayCast2D = $DownRaycast
@onready var current_location_ray_cast: RayCast2D = $CurrentLocationRayCast

@export var move_time:float= 0.3

enum{
	IDLE,
	MOVING
}
var state = IDLE

var current_location: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_location = current_location_ray_cast.get_collider()
	print(current_location)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			if Input.is_action_just_pressed("action"):
				pass
			if Input.is_action_just_pressed("up"):
				attempt_move("up")
			if Input.is_action_just_pressed("down"):
				attempt_move("down")
			if Input.is_action_just_pressed("left"):
				attempt_move("left")
			if Input.is_action_just_pressed("right"):
				attempt_move("right")
		MOVING:
			pass

func attempt_move(direction):
	var attempt_raycast:Node2D
	match direction:
		"up":
			attempt_raycast = up_raycast
		"down":
			attempt_raycast = down_raycast
		"left":
			attempt_raycast = left_raycast
		"right":
			attempt_raycast = right_raycast
	var move_target = attempt_raycast.get_collider()
	print(move_target)
	if !move_target: 
		print("no terrain")
		return false
	if move_target.occupied:
		print("terrain occupied")
		return false
	#var move_location = move_target.global_position
	var move_tween = get_tree().create_tween()
	move_tween.set_ease(Tween.EASE_IN_OUT)
	#move_tween.set_trans(Tween.TRANS_QUAD)
	move_tween.set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self,"global_position",move_target.global_position,move_time)
	#global_position = move_target.global_position
	if current_location:
		current_location.occupied = null
	move_target.occupied = self
	current_location = move_target
	return true
