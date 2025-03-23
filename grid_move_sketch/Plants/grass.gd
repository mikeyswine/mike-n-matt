extends Area2D


@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var reset_timer: Timer = $ResetTimer


enum{
	CUT,
	LONG
}
var state = LONG

##TODO This will either check for or be called by a tool in the end
func use():
	cut()

func take_damage():
	cut()

func regrow():
	state = LONG
	$CollisionShape2D.call_deferred("set_disabled", false)
	$Sprite2D.visible = true


func cut():
	if state == CUT: 
		return
	state = CUT
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	reset_timer.start()#randi_range(9.0,11.0))
	#call_deferred("set_monitoring", false)
	#call_deferred("set_monitorable", false)
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite2D.visible = false


func _on_cpu_particles_2d_finished() -> void:
	pass
	#queue_free()

func _on_reset_timer_timeout() -> void:
	regrow()
