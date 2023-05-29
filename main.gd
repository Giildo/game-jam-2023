extends Node


# Declare member variables here. Examples:
var spawners = []
var finished = 0
var current_characters = []
var is_in_game = false

var current_height = 0
var max_height = 0
export var min_max_height = 1
export var meter_unit = 150
export var base_items_count = {
	2: 50,
	3: 55,
	4: 60,
}

var available_items = 0

func start_game(characters: Array) -> void:
	$Lobby.stream_paused = true
	$Game.stream_paused = false
	
	$Record.stop()
	$GameOver.stop()
	
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
	_load_data()
	
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
	
	current_height = abs(stepify($SmoothCamera/HeightEstimator.get_height() / meter_unit, 0.01))
	$CanvasLayer/HUD/HeightCount/Value.text = str(current_height)
	yield(get_tree().create_timer(0.1), "timeout")
	
	_update_height()


func _ready():
	$Game.stream_paused = true
	
	$CanvasLayer/HUD.hide()
	$CanvasLayer/EndGameScreen.hide()
	$CanvasLayer/EndGameScreen/HBoxContainer/Lobby.show()
	
	$SmoothCamera.connect('item_lost', self, "_lost_item")

func _lost_item() -> void:
	_decrease_spawn()
	_decrease_spawn()
	

func _update_count_display():
	$CanvasLayer/HUD/ItemsCount/Value.text = str(available_items)


func _decrease_spawn():
	if available_items == 0:
		return
	
	available_items -= 1
	if available_items == 0:
		for s in spawners:
			s.can_spawn = false
	_update_count_display()


func _load_data() -> void:
	var saveFile = File.new()
	if not saveFile.file_exists('user://score.cfg'):
		_save_score()
	saveFile.open('user://score.cfg', File.READ)
	var data = parse_json(saveFile.get_as_text())
	if not data:
		max_height = min_max_height
	else:
		max_height = data.score if data.score > min_max_height else min_max_height
		
	$CanvasLayer/HUD/MaxHeight/Value.text = str(max_height)
	$goal.position.y = $SmoothCamera/HeightEstimator.inital_height - max_height * meter_unit

func _save_score() -> void:
	if (current_height > max_height):
		$CanvasLayer/EndGameScreen/Sticker.show()
		$CanvasLayer/EndGameScreen/VBoxContainer/HighScore/Label.hide()
		
		var data = {
			"score": current_height,
		}
		max_height = current_height
		
		var saveFile = File.new()
		saveFile.open("user://score.cfg", File.WRITE)
		saveFile.store_line(to_json(data))
		saveFile.close()
	

func end_game():
	
	
	$Game.stream_paused = true
	if (current_height > max_height):
		$Record.play()
	else:
		$GameOver.play()
	
	
	$CanvasLayer/EndGameScreen/Sticker.hide()
	$CanvasLayer/EndGameScreen/VBoxContainer/HighScore/Label.show()
	is_in_game = false
	yield(get_tree().create_timer(1.0),"timeout")
	_save_score()
	
	$CanvasLayer/HUD.hide()
	$CanvasLayer/EndGameScreen/VBoxContainer/VBoxContainer/Score.text = str(current_height) + "m"
	$CanvasLayer/EndGameScreen/VBoxContainer/HighScore/Score.text = str(max_height) + "m"
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
	$Game.stream_paused = true
	$Lobby.stream_paused = false
	$Record.stop()
	$GameOver.stop()
