extends Area2D
var baskets: Array = []


func _ready() -> void:
    baskets = get_tree().get_nodes_in_group("baskets")

func get_basket(produce_type: String, overripe: bool) -> Area2D:
    for basket in baskets:
        if basket.produce_type == produce_type and basket.produce_overripe == overripe:
            return basket
    return null

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("get_stored"):
        var basket = get_basket(body.name, body.overripe)
        basket.add_produce(body.overripe)
        body.get_stored()
