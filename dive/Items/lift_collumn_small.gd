class_name LiftCollumnSmall
extends Area2D

@export var disabled_height: int = 2
@export var small_height: int = 10
@export var big_height: int = 60
@export var disabled_particles_amount: int = 1
@export var small_particles_amount: int = 3
@export var big_particles_amount: int = 20
@export var disabled_particles_lifetime: int = 1
@export var small_particles_lifetime: int = 1
@export var big_particles_lifetime: int = 3

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_collider(small_height)
	cpu_particles_2d.amount = small_particles_amount
	cpu_particles_2d.lifetime = small_particles_lifetime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_collider(height):
	if collision_shape_2d != null:
		collision_shape_2d.shape.size.y = height
		collision_shape_2d.position.y = -height/2

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("start_float"):
		body.start_float()


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("stop_float"):
		body.stop_float()
		
func activate():
	update_collider(big_height)
	cpu_particles_2d.amount = big_particles_amount
	cpu_particles_2d.lifetime = big_particles_lifetime

func deactivate():
	update_collider(small_height)
	cpu_particles_2d.amount = small_particles_amount
	cpu_particles_2d.lifetime = small_particles_lifetime

func disable():
	update_collider(disabled_height)
	cpu_particles_2d.amount = disabled_particles_amount
	cpu_particles_2d.lifetime = disabled_particles_lifetime
