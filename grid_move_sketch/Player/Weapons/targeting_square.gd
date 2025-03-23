extends RayCast2D

func attack():
	var target = get_collider()
	if !target: return
	if target.has_method("take_damage"): target.take_damage()
