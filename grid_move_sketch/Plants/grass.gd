extends Area2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2

var description := "Grass"
var use_description := "Cut"
var growth_counter:= 0

enum{
	CUT,
	LONG
}
var state = LONG

func _ready() -> void:
	var theClock = get_node("/root/World/Clock")
	theClock.time_has_elapsed.connect(_time_elapsed)
	



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
	growth_counter = 0
	#call_deferred("set_monitoring", false)
	#call_deferred("set_monitorable", false)
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite2D.visible = false

func get_description():
	return description

func _on_cpu_particles_2d_finished() -> void:
	pass
	#queue_free()

func _time_elapsed():
	growth_counter += 1
	if growth_counter >= 5:
		growth_counter = 0
		regrow()
