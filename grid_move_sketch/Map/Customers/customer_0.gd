extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shopping_timer: Timer = $ShoppingTimer

var speed:= 2.0
var leaving_odometer:= 0.0


enum {
    ARRIVING,
    SHOPPING,
    LEAVING
}
var state = ARRIVING

func _ready() -> void:
    animated_sprite_2d.play("walk")
    animated_sprite_2d.flip_h = true
    velocity = Vector2.ZERO
    roll_character()

func _physics_process(delta: float) -> void:
    match state:
        ARRIVING:
            velocity.x = -speed
            var collision = move_and_collide(velocity*delta)
            if collision:
                var potential_shop = collision.get_collider().get_parent()
                if potential_shop.has_method("buy"):
                    potential_shop.buy(Vector2(global_position.x,global_position.y-30))
                    start_shopping()
                    return
        SHOPPING:
            velocity.x = 0
        LEAVING:
            velocity.x = speed
            var collision = move_and_collide(velocity*delta)
            if collision:
                queue_free()

func start_shopping():
    animated_sprite_2d.play("idle")
    state = SHOPPING
    shopping_timer.start()

func finish_shopping():
    animated_sprite_2d.play("walk")
    animated_sprite_2d.flip_h = false
    state = LEAVING

func _on_shopping_timer_timeout() -> void:
    finish_shopping()

func roll_character():
    shopping_timer.wait_time = randf_range(0.8,3.0)
    modulate = Color(
        randf_range(0.7,1.0),
        randf_range(0.7,1.0),
        randf_range(0.7,1.0))
    speed = randf_range(40.0,80.0)
