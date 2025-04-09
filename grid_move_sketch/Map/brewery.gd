extends Area2D

@onready var boiler_animation_player: AnimationPlayer = $Boiler/BoilerAnimationPlayer

var title:= "Brewery"
var action:= "brew"

var brewing := false

func get_info() -> Dictionary:
	var use_info = {}
	use_info.title = title
	if action:
		use_info.action = action
	return use_info

func use() -> bool:
	if brewing:
		action = "brew"
		boiler_animation_player.play("RESET")
		brewing = false
	else:
		action = "stop brewing"
		boiler_animation_player.play("boil")
		brewing = true
	return true
