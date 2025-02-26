extends Node2D

## A VERY Simple, self contained key and lock.
## Made to use within one level, without having to handle a 
## persistent player inventory. (Which we should totally 
##also consider for metroidvania hijinx)

const LOCKED_SOUND = preload("res://Items/Chest/impactSoft_medium_000.ogg")
const OPEN_SOUND = preload("res://Items/Chest/impactMining_003.ogg")
const UNLOCK_SOUND = preload("res://Items/Chest/impactTin_medium_000.ogg")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var contents = preload("res://Items/gravity_coin.tscn")
@export var contents_count: int = 5

var unlocked:bool = false
var full:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = 4
	
## Handle Key Pickup
func _on_key_area_body_entered(body: Node2D) -> void:
	print("Key Entered")
	audio_stream_player.stream = UNLOCK_SOUND
	audio_stream_player.play()
	unlocked = true
	$ChestKey.queue_free()

## Handle Attempts to Open Chest
func _on_chest_area_body_entered(body: Node2D) -> void:
	if unlocked:
		if full:
			audio_stream_player.stream = OPEN_SOUND
			audio_stream_player.play()
			$Sprite2D.frame = 5
			full = false
			for i in contents_count:
				var new_content = contents.instantiate()
				new_content.global_position = Vector2(global_position.x, global_position.y-4)
				get_tree().get_current_scene().call_deferred("add_child",new_content)
	else:
		audio_stream_player.stream = LOCKED_SOUND
		audio_stream_player.play()
