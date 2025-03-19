extends Area2D

var enabled = true

func _ready() -> void:
    if PlayerSingleton.has_anchor:
        queue_free()

func _on_body_entered(body: Node2D) -> void:
    PlayerSingleton.has_anchor = true
    set_deferred("monitoring", false)
    $AnimationPlayer.play("pickup")

func enable() -> void:
    enabled = true
    visible = true
    get_node("CollisionShape2D").disabled = false

func disable() -> void:
    enabled = false
    visible = false
    get_node("CollisionShape2D").disabled = true
