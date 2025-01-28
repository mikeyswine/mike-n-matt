extends Node2D

@onready var explosion_particles: CPUParticles2D = $ExplosionParticles
@onready var bubble_particles: CPUParticles2D = $BubbleParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosion_particles.emitting = true
	bubble_particles.emitting = true
	



func _on_bubble_particles_finished() -> void:
	queue_free()

func _on_explosion_particles_finished() -> void:
	pass # Replace with function body.
	#Once we add hitboxes, I might just use this to disable the hitbox.
