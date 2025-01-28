extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var pearl: Area2D = $Pearl


@export var wait_to_close: float = 4.0
@export var wait_to_open: float = 4.0


## Enumerator to describe possible states
enum {
	OPEN,
	CLOSING,
	CLOSED,
	OPENING
}

## Initial State
var state = OPEN


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = OPEN
	timer.start(wait_to_close)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if state == OPEN:
		state = CLOSING
		if pearl.collected:
			animated_sprite_2d.play('close_without_pearl')
		else:
			animated_sprite_2d.play('close')
	elif state == CLOSED:
		state = OPENING
		if pearl.collected:
			animated_sprite_2d.play('open_without_pearl')
		else:
			animated_sprite_2d.play('open')


func _on_animated_sprite_2d_animation_finished() -> void:
	if state == CLOSING:
		state = CLOSED
		pearl.collision_shape_2d.disabled = true
		for body in get_overlapping_bodies():
			if body.name == 'Player':
				body.take_damage()
		timer.start(wait_to_open)
	elif state == OPENING:
		state = OPEN
		if not pearl.collected:
			pearl.collision_shape_2d.disabled = false
		timer.start(wait_to_close)


func _on_pearl_body_entered(body: Node2D) -> void:
	#Change clam animations/sprites to those without pearl
	var current_frame = animated_sprite_2d.get_frame()
	var current_progress = animated_sprite_2d.get_frame_progress()
	var current_animation = animated_sprite_2d.get_animation()
	if current_animation == 'open':
		#animated_sprite_2d.play("open_without_pearl")
		animated_sprite_2d.set_animation("open_without_pearl")
	if current_animation == 'close':
		#animated_sprite_2d.play("close_without_pearl")
		animated_sprite_2d.set_animation("close_without_pearl")
		animated_sprite_2d.set_frame_and_progress(current_frame, current_progress)
