extends Node


# Declare member variables here. Examples:
var spawners = []
var finished = 0
var current_characters = []
var is_in_game = false

var current_height = 0

export var meter_unit = 150
export var base_items_count = {
	2: 20,
	3: 55,
	4: 60,
}

var available_items = 0

func start_game(characters: Array) -> void:
	for b in get_tree().get_nodes_in_group('blocs'):
		b.queue_free()
	for s in spawners:
		s.queue_free()
	spawners.clear()
	
	$SmoothCamera.position = Vector2.ZERO
	finished = 0
	current_characters = characters
	available_items = base_items_count[characters.size()]
	_update_count_display()
	$CanvasLayer/HUD.show()
	
	yield(get_tree().create_timer(1.0), "timeout")
	for i in range(characters.size()):
		var spawner = Spawner.new(characters[i], characters.size(), i)
		spawner.connect("has_spawned", self, "_decrease_spawn")
		spawner.connect("finished", self, "_check_finished")
		spawners.append(spawner)
		add_child(spawner)
	
	is_in_game = true
	_update_height()

func _check_finished():
	finished += 1
	if finished == spawners.size():
		end_game()


func _update_height():
	if not is_in_game:
		return
	
	current_height = ceil($SmoothCamera/HeightEstimator.get_height() / meter_unit)
	$CanvasLayer/HUD/HeightCount/Value.text = str(current_height)
	yield(get_tree().create_timer(0.1), "timeout")
	
	_update_height()


func _ready():
	$CanvasLayer/HUD.hide()
	$CanvasLayer/EndGameScreen.hide()
	$CanvasLayer/EndGameScreen/HBoxContainer/Lobby.show()


func _update_count_display():
	$CanvasLayer/HUD/ItemsCount/Value.text = str(available_items)


func _decrease_spawn():
	print_debug(available_items)
	available_items -= 1
	if available_items == 0:
		for s in spawners:
			s.can_spawn = false
	_update_count_display()




func end_game():
	is_in_game = false
	yield(get_tree().create_timer(1.0),"timeout")
	$CanvasLayer/HUD.hide()
	$CanvasLayer/EndGameScreen/VBoxContainer/VBoxContainer/Score.text = str(current_height) + "m"
	$CanvasLayer/EndGameScreen.show()
	

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


func _on_EndGameScreen_restart_requested():
	$CanvasLayer/EndGameScreen.hide()
	start_game(current_characters)
	


func _on_EndGameScreen_menu_requested():
	$CanvasLayer/EndGameScreen.hide()
	$CanvasLayer/Lobby.reset_selection()
	
	$CanvasLayer/Lobby.show()
