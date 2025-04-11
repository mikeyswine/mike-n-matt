extends Area2D

@onready var boiler_animation_player: AnimationPlayer = $Boiler/BoilerAnimationPlayer
@onready var fermenter_animation_player: AnimationPlayer = $Fermenter/FermenterAnimationPlayer

@onready var boiler_liquid: Sprite2D = $Boiler/BoilerLiquid
@onready var fermenter_liquid: Sprite2D = $Fermenter/FermenterLiquid

@onready var boiler_audio_stream_player_2d: AudioStreamPlayer2D = $Boiler/BoilerAudioStreamPlayer2D

@export var liquid_color:Color = Color.WEB_PURPLE

var title:= "Brewery"
var action:= "brew"

var brew_progress: int = 0

func _ready() -> void:
	var theClock = get_node("/root/World/Clock")
	theClock.time_has_elapsed.connect(_time_elapsed)


func get_info() -> Dictionary:
	update_brew_progress()
	var use_info = {}
	use_info.title = title
	if action:
		use_info.action = action
	return use_info

func use() -> bool:
	if brew_progress == 0:
		brew_progress = 1
		update_brew_progress()
		fermenter_liquid.modulate = liquid_color
		boiler_liquid.modulate = liquid_color
		return true
	update_brew_progress()
	return false
	#if brewing:
		#action = "brew"
		#boiler_animation_player.play("RESET")
		#brewing = false
	#else:
		#action = "stop brewing"
		#boiler_animation_player.play("boil")
		#brewing = true

func _time_elapsed():
	if brew_progress > 0:
		brew_progress += 1
		update_brew_progress()

func update_brew_progress():
	if brew_progress == 0:
		title = "Brewery: Idle"
		action = "brew"
		boiler_animation_player.play("RESET")
		fermenter_animation_player.play("RESET")
		boiler_audio_stream_player_2d.stop()
		return
	if brew_progress <= 8:
		title = "Brewery: Brewing"
		action = ""
		boiler_animation_player.play("boil")
		fermenter_animation_player.play("RESET")
		boiler_audio_stream_player_2d.play()
		return
	if brew_progress <= 20:
		title = "Brewery: Fermenting"
		action = ""
		boiler_animation_player.play("RESET")
		fermenter_animation_player.play("ferment")
		boiler_audio_stream_player_2d.stop()
		return
	brew_progress = 0
	update_brew_progress()
