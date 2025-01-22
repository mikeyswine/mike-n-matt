extends Node2D

@onready var player: CharacterBody2D = $Player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		add_blood_to_player()
	
	
func add_blood_to_player():
	var blood_splatter = load("res://Items/blood_splatter.tscn").instantiate()
	blood_splatter.emitting = true
	player.add_child(blood_splatter)
	#player.queue_free()
	
