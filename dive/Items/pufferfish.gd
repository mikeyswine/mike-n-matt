extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var unpuffed_speed = 0.8
@export var puffed_speed = 0.1
@export var puffed_rise = 0.15

var puffed:bool = false
var direction: float = -1.0


func _physics_process(delta: float) -> void:
	if puffed:
		velocity.x = direction * puffed_speed
		velocity.y = -puffed_rise
	else:
		velocity.x = direction * unpuffed_speed
	
	var collision = move_and_collide(velocity)
	if collision:
		direction = -direction
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		var body = collision.get_collider()
		if body.has_method("get_high"):
			body.get_high()
			puffed = true
			animated_sprite_2d.play("puffed")
		move_and_slide()
		## TODO Await timer yadda yadda
