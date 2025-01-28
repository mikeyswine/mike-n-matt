extends Node2D

const SPEED = 60

var direction = -1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		if ray_cast_right.get_collider().get_name() != "Player":
			direction = -1
			animated_sprite_2d.flip_h = false
	if ray_cast_left.is_colliding():
		if ray_cast_left.get_collider().get_name() != "Player":
			direction = 1
			animated_sprite_2d.flip_h = true
	
	position.x += direction * SPEED * delta


# Not used. From when Enemy was Node and contained an Area2D Node.
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
		#body.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		body.take_damage()
	
