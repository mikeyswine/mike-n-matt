extends Area2D

const PEPPER_PLANT = preload("res://Plants/pepper_plant.tscn")

var baskets: Array = []
var produce: Dictionary = {
    'Pepper': 4,
    'Overripe Pepper': 0}
var selected_basket:= "Pepper"
var gold:= 50
@onready var store_house_label: Label = %StoreHouseLabel


func _ready() -> void:
    baskets = get_tree().get_nodes_in_group("baskets")
    for basket in baskets:
        if basket.produce_type == selected_basket:
            if basket.has_method("select"):
                basket.select()


func get_basket(produce_type: String) -> Area2D:
    for basket in baskets:
        if basket.produce_type == produce_type:
            return basket
    return null


func _on_body_entered(body: Node2D) -> void:
    # Handle Gold
    if body.produce_type == "gold":
        gold = gold + 1
        store_house_label.text = str(gold)
        return
    # Handle Produce
    var basket = get_basket(body.produce_type)
    var prior_produce = produce[body.produce_type] ## I think this is unused?
    produce[body.produce_type] += 1
    basket.add_produce()
    body.queue_free()


## Basket calls this to set the currently selected produce to plant, brew, stock at farmstand, etc.
func select_basket(new_basket_choice, overripe):
    selected_basket = new_basket_choice
    for basket in baskets:
        if (basket.produce_type != new_basket_choice) or (basket.produce_overripe != overripe):
            basket.deselect()


## Soil, Brewery, Farmstand, etc. calls this to try to consume 1 stored produce for it's own purposes.
func request_produce() -> String:
    ## Make sure produce is in stock.
    if produce[selected_basket] <= 0:
        return ""
        
    produce[selected_basket] -= 1
    get_basket(selected_basket).remove_produce()
    return str(selected_basket)


## Soil, Brewery, Farmstand call this to see what's selected.  
## Returns the name of the selected basket if any are available.
func request_info() -> String:
    if produce[selected_basket] <= 0:
        return ""
    return selected_basket
    
