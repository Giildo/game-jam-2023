extends Node


# Declare member variables here. Examples:
var spawners: Array

export var base_items_count = {
	2: 10,
	3: 55,
	4: 60,
}

var available_items = 0

func start_game(characters: Array) -> void:
	available_items = base_items_count[characters.size()]
	_update_count_display()
	
	for i in range(characters.size()):
		var spawner = Spawner.new(characters[i], characters.size(), i)
		spawner.connect("has_spawned", self, "_decrease_spawn")
		spawners.append(spawner)
		add_child(spawner)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _update_count_display():
	$CanvasLayer/HUD/ItemsCount/Value.text = str(available_items)


func _decrease_spawn():
	print_debug(available_items)
	available_items -= 1
	if available_items == 0:
		for s in spawners:
			s.can_spawn = false
	_update_count_display()


func get_scroll_direction() -> float:
	$Top.force_raycast_update()
	$Bottom.force_raycast_update()
	
	var top = $Top.is_colliding()
	var bottom = $Bottom.is_colliding()
	
	if top:
		return -1.0
	elif bottom:
		return 0.0
	else:
		return -1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Lobby_game_start_requested(characters):
	start_game(characters)
