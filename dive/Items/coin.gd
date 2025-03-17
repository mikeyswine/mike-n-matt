extends Area2D

var enabled = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_body_entered(body: Node2D) -> void:
    body.increment_coins()
    queue_free()
    
func enable() -> void:
    enabled = true
    visible = true
    get_node("CollisionShape2D").disabled = false

func disable() -> void:
    enabled = false
    visible = false
    get_node("CollisionShape2D").disabled = true
