extends Area2D
var baskets: Array = []
# key 'ProduceName', value [ripe count: index 0, overripe count: index 1]. 
var produce: Dictionary = {'PepperProduce': [0,0]}


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
        var prior_produce = produce[body.name]
        if not body.overripe: 
            produce[body.name][0] += 1
        else:
            produce[body.name][1] += 1
        basket.add_produce(body.overripe)
        body.get_stored()
