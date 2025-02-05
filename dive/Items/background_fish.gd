extends AnimatedSprite2D

@export var speed := 10.0
@export var distance := 132
@export var delay_randomization := 30.0


#func _ready() -> void:
	#_reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += speed * delta
	if position.x > distance:
		_reset()

func _reset():
	print("Fish Reset")
	position.x = -16 - randi_range(0.0,delay_randomization)
	print(position.x)
	position.y = randi_range(16,164)
