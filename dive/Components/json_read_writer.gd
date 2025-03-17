extends Node2D

class_name JsonReadWriter

var level_name = null
var save_nodes = null
var save_path := "user://player_data.json"

# Absolute path for Mike:
#/Users/michaelarnoult/Library/Application Support/Godot/app_userdata/Dive
var absolute_path_to_files = OS.get_user_data_dir()

# Alternate storage option:
#var file = FileAccess.open(json_file_path, FileAccess.WRITE)
#if file:
    #var json_string = JSON.stringify(data)
    #file.store_line(json_string)
    #file.close()
    

func _ready() -> void:
    level_name = get_tree().get_current_scene().name
    load_game()
    
func _process(delta: float) -> void:
    if Input.is_action_pressed("grab"):
        save()
    if Input.is_action_pressed("enable_persistent_items"):
        enable_persistent_items()

func save() -> void:
    
    save_nodes = get_tree().get_nodes_in_group("persistent")
    var persistent_node_name_list = []
    for item in save_nodes:
        if item.enabled:
            persistent_node_name_list.append(item.name)
    
    var data := {
        "level_name": level_name,
        get_tree().get_current_scene().name: persistent_node_name_list
        
    }
    
    var json_data := JSON.stringify(data)

    # We will need to open/create a new file for this data string
    var file_access := FileAccess.open(save_path, FileAccess.WRITE)
    if not file_access:
        print("An error happened while saving data: ", FileAccess.get_open_error())
        return

    file_access.store_line(json_data)
    file_access.close()
    
func load_game() -> void:
    var persistent_nodes = get_tree().get_nodes_in_group("persistent")
    if not FileAccess.file_exists(save_path):
        return
    var file_access := FileAccess.open(save_path, FileAccess.READ)
    var json_string := file_access.get_line()
    file_access.close()

    var json := JSON.new()
    var error := json.parse(json_string)
    if error:
        print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
        return
    
    var data:Dictionary = json.data
    var saved_persistent_nodes = data[get_tree().get_current_scene().name]
        
    for persistent_node in persistent_nodes:
        if persistent_node.name not in saved_persistent_nodes:
            persistent_node.disable()
            
func enable_persistent_items():
    var persistent_nodes = get_tree().get_nodes_in_group("persistent")
    for persistent_node in persistent_nodes:
        persistent_node.enable()
