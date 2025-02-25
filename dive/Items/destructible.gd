extends CharacterBody2D


const SINK_RATE = 10
@export var make_debris: bool = false
@export var test_damage: bool = false

@onready var left_ray_cast_2d: RayCast2D = $LeftRayCast2D

@onready var right_ray_cast_2d: RayCast2D = $RightRayCast2D
@onready var down_ray_cast_2d: RayCast2D = $DownRayCast2D
@onready var up_ray_cast_2d: RayCast2D = $UpRayCast2D
@onready var ray_casts = [left_ray_cast_2d, right_ray_cast_2d, down_ray_cast_2d, up_ray_cast_2d]

var is_destroyed = false



func _physics_process(delta: float) -> void:
	
	# For testing, elicit take_damage on button press
	if Input.is_action_pressed("grab"):
		if test_damage:
			take_damage()
	
	#
	### Destructible does not sink (but debris does)
	#if not is_on_floor():
		#velocity += Vector2(0,SINK_RATE) * delta 
#
	### Destructible does not move.
	#move_and_slide()
	
func take_damage():
	# No need to proceed if state already is_destroyed.
	if is_destroyed:
		return
	else:
		is_destroyed = true
	
	# Possibly use similar logic to mine._on_detonation_timer_timeout()
	#visible = false
	# This might function -kind of- like disabling?
	#get_tree().paused = true
	
	
	# Use Raycasts left, right, up, and down to detect other Destructibles.
	# If any exist, call take_damage() on those as well.
	for ray_cast in ray_casts:
		var colliding_before = ray_cast.is_colliding()
		var colliding_objects: Array = get_all_raycast_collided_objects(ray_cast)
		if test_damage:
			var colliding_after = ray_cast.is_colliding()
			print(ray_cast.is_colliding())
			print(ray_cast.name)
		for colliding_object in colliding_objects:
			# Check if any coliding object is also a Destructible.
			if 'is_destroyed' in colliding_object:
				colliding_object.take_damage()
				
	if make_debris:
		var debris = load("res://Items/debris.tscn").instantiate()
		debris.position = position
		# Place debris where this destructible is and make it a child
		# of the World node.
		get_parent().call_deferred("add_child",debris)
		
	# Finally, remove Destructible.
	queue_free()
	
# Plagarized from a forum.
func get_all_raycast_collided_objects(ray: RayCast2D) -> Array:
	var objects_collide = [] #The colliding objects go here.
	while ray.is_colliding():
		var obj = ray.get_collider() #get the next object that is colliding.
		objects_collide.append( obj ) #add it to the array.
		ray.add_exception( obj ) #add to ray's exception. That way it could detect something being behind it.
		ray.force_raycast_update() #update the ray's collision query.

	#after all is done, remove the objects from ray's exception.
	for obj in objects_collide:
		ray.remove_exception( obj )
	ray.force_raycast_update() #update the ray's collision query.
	
	return objects_collide
