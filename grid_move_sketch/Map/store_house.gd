extends Area2D
var baskets: Array = []
# key 'ProduceName', value [ripe count: index 0, overripe count: index 1]. 
var produce: Dictionary = {'Pepper': [0,0]}
var selected_basket := "Pepper"


func _ready() -> void:
	baskets = get_tree().get_nodes_in_group("baskets")
	for basket in baskets:
		if (basket.produce_type == selected_basket) and !basket.produce_overripe:
			if basket.has_method("select"):
				basket.select()

func get_basket(produce_type: String, overripe: bool) -> Area2D:
	for basket in baskets:
		if basket.produce_type == produce_type and basket.produce_overripe == overripe:
			return basket
	return null

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_stored"):
		var basket = get_basket(body.produce_type, body.overripe)
		var prior_produce = produce[body.produce_type]
		if not body.overripe: 
			produce[body.produce_type][0] += 1
		else:
			produce[body.produce_type][1] += 1
		basket.add_produce(body.overripe)
		body.get_stored()

func select_basket(new_basket_choice, overripe):
	selected_basket = new_basket_choice
	for basket in baskets:
		if (basket.produce_type != new_basket_choice) or (basket.produce_overripe != overripe):
			basket.deselect()
