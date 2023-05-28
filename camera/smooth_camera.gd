extends Camera2D

var scroll_offset = 0.0

func _on_Timer_timeout():
	var height = 1080 - $HeightEstimator.get_tower_distance_from_top()
	position.y = -height + 200
