extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
const PLOT = preload("res://Plants/plot.tscn")
const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
const PEPPER_REMOVED_PARTICLES = preload("res://Plants/pepper_removed_particles.tscn")

var growth_state:=0
var state_name:= "seed"
var action_name:String
#var picked:= false

func _ready() -> void:
	var theClock = get_node("/root/World/Clock")
	theClock.time_has_elapsed.connect(_time_elapsed)
	sprite_2d.frame = 0


func growth_step():
	growth_state += 1
	update_growth_state()

## Handle Growth Process of plant in steps.  Can set up states farther appart in order to make a 
##state last a differing duration.
func update_growth_state():
	## I know I could've handled this by parsing a dictionary or other datatype
	## loaded up with state info, but I think this is more readable and flexible =)
	match growth_state:
		1,2,3:
			state_name= "sprout"
			sprite_2d.frame = 1
		4,5,6:
			state_name= "young"
			sprite_2d.frame = 2
		7,8,9:
			state_name= "maturing"
			sprite_2d.frame = 3
		10,11,12:
			state_name= "mature"
			sprite_2d.frame = 4
		13,14,15:
			state_name= "flowering"
			sprite_2d.frame = 5
		16,17,18:
			state_name= "ripening"
			sprite_2d.frame = 6
		19,20,21,22,23,24,25,26,27,28,29,30:
			state_name="ripe"
			sprite_2d.frame = 7
			#if picked:
				#state_name = "picked"
				#sprite_2d.frame = 4
			#else:
				#state_name="ripe"
				#sprite_2d.frame = 7
		31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49:
			state_name = "overripe"
			sprite_2d.frame = 8
			#if picked:
				#state_name = "senescent"
				#sprite_2d.frame = 9
			#else:
				#state_name = "overripe"
				#sprite_2d.frame = 8
		50,51,52,53,54,55:
			state_name = "senescent"
			sprite_2d.frame = 9
		56, _:
			state_name = "dead"
			sprite_2d.frame = 10
	#print(state_name)


func use():
	if state_name == "ripe":
		print ("picked ripe peppers")
		spawn_produce(false)
		#picked = true
		growth_state = 50
		update_growth_state()
	if state_name == "overripe":
		print ("picked overripe peppers")
		spawn_produce(true)
		#picked = true
		growth_state = 50
		update_growth_state()
	if state_name == "dead":
		#death_particles.emitting = true
		#$Sprite2D.visible = false
		#set_collision_layer_value(3,false)
		
		## Spawn Removal Effect
		var new_effect = PEPPER_REMOVED_PARTICLES.instantiate()
		new_effect.global_position = global_position
		get_tree().get_current_scene().call_deferred("add_child", new_effect)
		
		## Spawn in Empty Plot
		var new_plot = PLOT.instantiate()
		new_plot.global_position = global_position
		get_tree().get_current_scene().call_deferred("add_child", new_plot)
		
		queue_free()

func _time_elapsed():
	print()
	growth_step()


func spawn_produce(is_overripe):
	var new_produce = PEPPER_PRODUCE.instantiate()
	new_produce.overripe = is_overripe
	new_produce.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_produce)
