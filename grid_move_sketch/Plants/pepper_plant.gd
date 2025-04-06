extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
const PLOT = preload("res://Plants/plot.tscn")
const PEPPER_PRODUCE = preload("res://Plants/pepper_produce.tscn")
const PEPPER_REMOVED_PARTICLES = preload("res://Plants/pepper_removed_particles.tscn")

var growth_state:=0
var state_name:= "seed"
var action_name:String

## For now, I got rid of the picked bool concept.  When the plant is picked, it
## just jumps ahead to the senescent phase.  This is to make the plant die in a more
## timely fashion if you pick early.
#var picked:= false


func _ready() -> void:
	var theClock = get_node("/root/World/Clock")
	theClock.time_has_elapsed.connect(_time_elapsed)
	sprite_2d.frame = 0


func _time_elapsed():
	print()
	growth_step()


func growth_step():
	growth_state += 1
	update_growth_state()


## Handle Growth Process of plant in steps.  Can set up states farther appart in order to make a 
##state last a differing duration.
func update_growth_state():
	match growth_state:
		1,2,3:
			state_name= "Sprouting"
			action_name= ""
			sprite_2d.frame = 1
		4,5,6:
			state_name= "Young"
			action_name= ""
			sprite_2d.frame = 2
		7,8,9:
			state_name= "Maturing"
			action_name= ""
			sprite_2d.frame = 3
		10,11,12:
			state_name= "Mature"
			action_name= ""
			sprite_2d.frame = 4
		13,14,15:
			state_name= "Flowering"
			action_name= ""
			sprite_2d.frame = 5
		16,17,18:
			state_name= "Ripening"
			action_name= ""
			sprite_2d.frame = 6
		19,20,21,22,23,24,25,26,27,28,29,30:
			state_name="Ripe"
			action_name= "Pick"
			sprite_2d.frame = 7
			#if picked:
				#state_name = "picked"
				#sprite_2d.frame = 4
			#else:
				#state_name="ripe"
				#sprite_2d.frame = 7
		31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49:
			state_name = "Overripe"
			action_name= "Pick"
			sprite_2d.frame = 8
			#if picked:
				#state_name = "senescent"
				#sprite_2d.frame = 9
			#else:
				#state_name = "overripe"
				#sprite_2d.frame = 8
		50,51,52,53,54,55:
			state_name = "Dying"
			action_name= ""
			sprite_2d.frame = 9
		56, _:
			state_name = "Dead"
			action_name= "Remove"
			sprite_2d.frame = 10
	#print(state_name)


func use() -> bool:
	match state_name:
		"Ripe":
			## Pick Ripe Fruit
			spawn_produce(false)
			#picked = true
			growth_state = 50
			update_growth_state()
			## Manually setting growth frame to handle corner case.
			sprite_2d.frame = 4
			return true
		"Overripe":
			## Pick Overripe Fruit
			spawn_produce(true)
			#picked = true
			growth_state = 50
			update_growth_state()
			return true
		"Dead":
			## Remove Dead Plant
			die()
			return true
		_:
			return false


func get_info() -> Dictionary:
	var use_info = {}
	use_info.title = str(state_name) + " Pepper Plant"
	if action_name:
		use_info.action = action_name
	return use_info


func spawn_produce(is_overripe,quantity = 1):
	var new_produce = PEPPER_PRODUCE.instantiate()
	new_produce.overripe = is_overripe
	new_produce.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_produce)


func die():
	## Spawn Removal Effect
	var new_effect = PEPPER_REMOVED_PARTICLES.instantiate()
	new_effect.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_effect)
	
	## Spawn in Empty Plot
	var new_plot = PLOT.instantiate()
	new_plot.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_plot)
	
	queue_free()
