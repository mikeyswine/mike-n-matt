extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var growth_state:=0
var state_name:= "seed"
var picked:= false


func growth_step():
	growth_state += 1
	update_growth_state()

## Handle Growth Process of plant in steps.  Can set up states farther appart in order to make a 
##state last a differing duration.
func update_growth_state():
	## I know I could've handled this by parsing a dictionary or other datatype
	## loaded up with state info, but I think this is more readable and flexible =)
	match growth_state:
		1:
			state_name= "sprout"
			sprite_2d.frame = 1
		2:
			state_name= "young"
			sprite_2d.frame = 2
		3:
			state_name= "maturing"
			sprite_2d.frame = 3
		4:
			state_name= "mature"
			sprite_2d.frame = 4
		5:
			state_name= "flowering"
			sprite_2d.frame = 5
		6:
			state_name= "ripening"
			sprite_2d.frame = 6
		7:
			if picked:
				state_name = "picked"
				sprite_2d.frame = 4
			else:
				state_name="ripe"
				sprite_2d.frame = 7
		9:
			if picked:
				state_name = "senescent"
				sprite_2d.frame = 9
			else:
				state_name = "overripe"
				sprite_2d.frame = 8
		13:
			state_name = "senescent"
			sprite_2d.frame = 9
		14:
			state_name = "dead"
			sprite_2d.frame = 10

func use():
	if state_name == "ripe":
		print ("picked ripe peppers")
		picked = true
		update_growth_state()
	if state_name == "overipe":
		print ("picked overipe peppers")
		picked = true
		update_growth_state()

func take_damage():
	queue_free()
	##TODO could add effect here.  could drop fruit if present.


func _on_growth_step_timer_timeout() -> void:
	growth_step()
