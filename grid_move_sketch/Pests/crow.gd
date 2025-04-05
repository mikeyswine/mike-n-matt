extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum {
	ARRIVING,
	WAITING,
	PECKING,
	FLEEING
}

var state = ARRIVING
@export var destination:= Vector2(500.0,0.0)
var speed = 200.0
var wait_time:int


func _ready() -> void:
	animation_player.play("fly")
	#set_deferred("monitoring", false)
	set_collision_mask_value(2,false)
	wait_time = randi_range(3,7)
	
	## Connect Clock Signal
	var theClock = get_node("/root/World/Clock")
	theClock.time_has_elapsed.connect(_time_elapsed)


func _physics_process(delta: float) -> void:
	match state:
		ARRIVING:
			global_position = global_position.move_toward(destination,speed*delta)
			if global_position == destination:
				state = WAITING
				#set_deferred("monitoring", true)
				set_collision_mask_value(2,true)
				animation_player.play("idle")
		WAITING:
			pass
		PECKING:
			pass
		FLEEING:
			animation_player.play("fly")
			global_position = global_position.move_toward(destination,speed*delta)
			if global_position == destination:
				queue_free()


## Decrement counter during WAITING state
func _time_elapsed():
	if state == WAITING:
		wait_time -= 1
		if wait_time <= 0:
			state = PECKING
			animation_player.play("peck_prep")


## Player has entered crow's range
func _on_area_entered(area: Area2D) -> void:
	#set_deferred("monitoring", false)
	set_collision_mask_value(2,false)
	destination.x = randf_range(destination.x -1000.0, destination.x + 1000.0)
	destination.y = destination.y - 2000
	state = FLEEING

func pecking():
	animation_player.play("pecking")
