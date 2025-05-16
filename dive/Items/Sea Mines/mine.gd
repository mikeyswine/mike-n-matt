extends CharacterBody2D

@onready var line_2d: Line2D = %Line2D
const MINE_EXPLOSION = preload("res://Items/Sea Mines/mine_explosion.tscn")
@onready var detonation_timer: Timer = $DetonationTimer
@onready var trigger_sound: AudioStreamPlayer = $TriggerSound
@onready var release_sound: AudioStreamPlayer = $"../ReleaseSound"


var horrizontal_range:float = 3.0
var drift_speed:float# = 0.03
var float_rate:float = 1.0
var randomize_home: bool = true
var randomize_speed: bool = true
var speed_rand_ammount: float = 0.01


var is_tethered = true
var is_armed = true

func _ready() -> void:
	if randomize_home:
		position.x = randf_range(-horrizontal_range/2, horrizontal_range/2)
	if randomize_speed:
		drift_speed = randf_range(drift_speed - speed_rand_ammount, drift_speed + speed_rand_ammount)
		velocity.x = drift_speed
		print("Randomizing Speed")
	else:
		drift_speed=get_parent().drift_speed



func _physics_process(delta: float) -> void:
	if is_tethered: 
		tethered(delta)
	else: 
		untethered(delta)
	
	var collision = move_and_collide(velocity)
	if collision: 
		if is_armed:
			print("Triggered by ")
			print(collision.get_collider())
			explode()


func tethered(delta):
	line_2d.set_point_position(1,position)
	if position.x >= horrizontal_range/2:
		velocity.x = -drift_speed
	if position.x <= -horrizontal_range/2:
		velocity.x = drift_speed


func untethered(delta):
	velocity.x = 0.0
	velocity.y -= float_rate * delta
	if position.y >= 100: queue_free()  ## Delete if it rises offscreen 

func explode():
	is_armed = false
	detonation_timer.start(randi_range(0.2,0.4))
	trigger_sound.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_tethered:
		is_tethered = false
		release_sound.play()
		line_2d.visible = false


func _on_detonation_timer_timeout() -> void:
	line_2d.visible = false
	var new_explosion = MINE_EXPLOSION.instantiate()
	new_explosion.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", new_explosion)
	queue_free()


func take_damage():
	explode()
