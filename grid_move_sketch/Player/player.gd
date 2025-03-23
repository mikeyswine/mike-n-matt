extends Area2D

@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast
@onready var up_raycast: RayCast2D = $UpRaycast
@onready var down_raycast: RayCast2D = $DownRaycast
@onready var current_location_ray_cast: RayCast2D = $CurrentLocationRayCast

@onready var use_raycast: RayCast2D = $UseRaycast

@onready var hand: Node2D = $Hand


@export var move_time:float= 0.3

enum{
	IDLE,
	MOVING,
	ATTACKING
}
var state = IDLE

enum{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var facing = UP

var my_weapon: Node2D

var current_location: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_location = current_location_ray_cast.get_collider()
	connect_weapon()
	


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
			pass
		ATTACKING:
			pass

func attempt_move(new_direction):
	##TODO Rework this functionality into the weapon.
	#if hand.get_children().size() >= 0:
		#if facing != direction:
			#change_weapon_direction(direction)
			#return
		#else:
			#print("facing == direction")
	
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
	if my_weapon:
		my_weapon.set_direction(new_direction)
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
	move_tween.set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self,"global_position",move_target.global_position,move_time)
	
	$Sprite2D.scale.y = 0.5
	var height_tween = get_tree().create_tween()
	height_tween.set_ease(Tween.EASE_IN)
	height_tween.set_trans(Tween.TRANS_BACK)
	height_tween.tween_property($Sprite2D,"scale:y",0.6,move_time)
	
	if current_location:
		current_location.occupied = null
	move_target.occupied = self
	current_location = move_target
	return true

## This functionality should actually be in the weapon to handle different types uniquely
func change_weapon_direction(new_direction):
	match new_direction:
		UP:
			facing = UP
			hand.position = Vector2(0,-80)
			hand.rotation_degrees = 0
		DOWN:
			facing = DOWN
			hand.position = Vector2(0,80)
			hand.rotation_degrees = 180
		LEFT:
			facing = LEFT
			hand.position = Vector2(-100,0)
			hand.rotation_degrees = 270
		RIGHT:
			facing = RIGHT
			hand.position = Vector2(100,0)
			hand.rotation_degrees = 90
	
func use():
	if my_weapon:
		my_weapon.attack()
		state = ATTACKING
		return
	var useable = use_raycast.get_collider()
	print(useable)
	if !useable: return
	if useable.has_method("use"): useable.use()
	useable = null

func connect_weapon():
	my_weapon = hand.get_children()[0]
	my_weapon.attack_done.connect(attack_is_done)
	print(my_weapon)

func attack_is_done():
	state = IDLE
