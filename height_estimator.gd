extends Node2D

var rays: Array

func _ready():
	rays = get_children()
	pass # Replace with function body.


func get_tower_heigh() -> float:
	var height_sum = 0.0
	for r in rays:
		r = (r as RayCast2D)
		r.force_raycast_update()
		height_sum += r.get_collision_point().y
	
	return height_sum / rays.size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
