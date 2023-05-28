extends Node2D

var rays: Array

func _ready():
	rays = get_children()


func get_tower_distance_from_top() -> float:
	var height_max = 99999999.0
	for r in rays:
		r = (r as RayCast2D)
		r.force_raycast_update()
		if r.is_colliding():
			height_max = min(height_max, r.get_collision_point().y) 
	
	return height_max
