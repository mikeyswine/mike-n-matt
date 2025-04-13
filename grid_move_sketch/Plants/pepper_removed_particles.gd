extends CPUParticles2D

func _ready() -> void:
    $AudioStreamPlayer.pitch_scale = randf_range(0.9,1.1)
    emitting = true

func _on_finished() -> void:
    queue_free()
