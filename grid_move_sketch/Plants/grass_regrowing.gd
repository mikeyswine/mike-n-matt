extends Area2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2

var title := "Grass"
var action_name := "Cut"
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
	return true

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



func _on_cpu_particles_2d_finished() -> void:
	pass
	#queue_free()

func _time_elapsed():
	growth_counter += 1
	if growth_counter >= 5:
		growth_counter = 0
		regrow()


func get_info() -> Dictionary:
	var use_info = {}
	use_info.title = title
	use_info.action = action_name
	return use_info
