extends Node2D

class_name JsonReadWriter

var level_name = null
var save_nodes = null
var save_path := "user://player_data.json"

# Absolute path for Mike:
#/Users/michaelarnoult/Library/Application Support/Godot/app_userdata/Dive
var absolute_path_to_files = OS.get_user_data_dir()

func _ready() -> void:
    level_name = get_tree().get_current_scene().name
    load_player_data()
    load_level_data()
    
func _process(delta: float) -> void:
    if Input.is_action_pressed("grab"):
        save_player_data()
        save_level_data()
    if Input.is_action_pressed("enable_persistent_items"):
        enable_persistent_items()
        
func write_data_to_json_file(data: Dictionary) -> void:
    var json_data := JSON.stringify(data)

    var file_access := FileAccess.open(save_path, FileAccess.WRITE)
    if not file_access:
        print("An error happened while saving data: ", FileAccess.get_open_error())
        return

    file_access.store_line(json_data)
    file_access.close()
    
func load_data_from_save_file() -> Dictionary:
    if not FileAccess.file_exists(save_path):
        print('File Not Accessible')
        return {}
    var file_access := FileAccess.open(save_path, FileAccess.READ)
    var json_string := file_access.get_line()
    file_access.close()

    var json := JSON.new()
    var error := json.parse(json_string)
    if error:
        print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
        return {}
    
    var data:Dictionary = json.data
    return data

func save_player_data() -> void:
    var data:Dictionary = load_data_from_save_file()
    data['player_data'] = {
        'has_anchor': PlayerSingleton.has_anchor,
        'coins': PlayerSingleton.coins,
        'inventory': PlayerSingleton.inventory
    }
    write_data_to_json_file(data)
    
func save_level_data() -> void:
    
    save_nodes = get_tree().get_nodes_in_group("persistent")
    var persistent_node_name_list = []
    for item in save_nodes:
        if item.enabled:
            persistent_node_name_list.append(item.name)
            
    var data:Dictionary = load_data_from_save_file()
    
    data[get_tree().get_current_scene().name] = persistent_node_name_list
    write_data_to_json_file(data)
    
func load_player_data() -> void:
    var data:Dictionary = load_data_from_save_file()
    
    # If player data has never been saved, save it.
    if not data.has('player_data'):
        save_player_data()
        data = load_data_from_save_file()
        
    PlayerSingleton.has_anchor = data['player_data']['has_anchor']
    PlayerSingleton.coins = data['player_data']['coins']
    PlayerSingleton.inventory = data['player_data']['inventory']
    
func load_level_data() -> void:
    var data:Dictionary = load_data_from_save_file()
    
    # If level has never been saved, enable all persistent items and save level.
    if not data.has(level_name):
        enable_persistent_items()
        save_level_data()
        data = load_data_from_save_file()
        
    var saved_persistent_nodes = data[level_name]
    
    var persistent_nodes = get_tree().get_nodes_in_group("persistent")
    for persistent_node in persistent_nodes:
        if persistent_node.name not in saved_persistent_nodes:
            persistent_node.disable()
            
func enable_persistent_items():
    var persistent_nodes = get_tree().get_nodes_in_group("persistent")
    for persistent_node in persistent_nodes:
        persistent_node.enable()
