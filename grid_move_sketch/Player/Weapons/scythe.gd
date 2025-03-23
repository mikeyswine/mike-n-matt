extends Node2D

@onready var target_up: Node2D = $TargetUp
@onready var target_down: Node2D = $TargetDown
@onready var target_left: Node2D = $TargetLeft
@onready var target_right: Node2D = $TargetRight
@onready var scythe_image: Node2D = $ScytheImage
@onready var animation_player: AnimationPlayer = $ScytheImage/AnimationPlayer


enum{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var facing = UP

@export var attacking:= false

signal attack_done

func _ready() -> void:
	disable_all_directions()

func _physics_process(delta: float) -> void:
	if attacking == false: return
	
	if Input.is_action_just_pressed("up"):
		enable_direction(UP)
	if Input.is_action_just_pressed("down"):
		enable_direction(DOWN)
	if Input.is_action_just_pressed("left"):
		enable_direction(LEFT)
	if Input.is_action_just_pressed("right"):
		enable_direction(RIGHT)
	
	if Input.is_action_just_pressed("action"):
		match facing:
			UP:
				scythe_image.rotation_degrees = 0
				target_up.attack()
				animation_player.play("attack_up")
			DOWN:
				scythe_image.rotation_degrees = 0
				target_down.attack()
				animation_player.play("attack_down")
			LEFT:
				scythe_image.rotation_degrees = 270
				target_left.attack()
				animation_player.play("attack_up")
			RIGHT:
				scythe_image.rotation_degrees = 90
				target_right.attack()
				animation_player.play("attack_up")
		done_attacking()
		print("scythe attacked")
	if Input.is_action_just_pressed("cancel"):
		animation_player.play("RESET")
		done_attacking()
		print("scythe cancelled")

func enable_direction(new_direction):
	facing = new_direction
	match new_direction:
			LEFT:
				facing = LEFT
				target_up.disable()
				target_down.disable()
				target_left.enable()
				target_right.disable()
			RIGHT:
				facing = RIGHT
				target_up.disable()
				target_down.disable()
				target_left.disable()
				target_right.enable()
			UP:
				facing = UP
				target_up.enable()
				target_down.disable()
				target_left.disable()
				target_right.disable()
			DOWN:
				facing = DOWN
				target_up.disable()
				target_down.enable()
				target_left.disable()
				target_right.disable()

func set_direction(new_direction):
	facing = new_direction

func attack():
	#attacking = true
	animation_player.play("wind_up")
	enable_direction(facing)
	print("scythe preparing to attack")

func disable_all_directions():
	target_up.disable()
	target_down.disable()
	target_left.disable()
	target_right.disable()

func done_attacking():
	attacking = false
	disable_all_directions()
	attack_done.emit()
