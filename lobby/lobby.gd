extends Control

var players: Array = []

signal game_start_requested(characters)

var players_count = 0
var can_play = false


func _input(event):
	if event is InputEventJoypadButton and event.is_pressed() and not event.is_echo():
		if event.button_index == JOY_START and can_play and visible:
			start_game()


func _ready():
	players = $Players.get_children()
	for p in players:
		p.connect("type_selected", self, "_on_player_selection")
		p.connect("type_deselected", self, "_on_player_deselection")
	_update_play_status()

func _on_player_selection(type):
	players_count += 1
	for p in players:
		(p as PlayerIcon).set_type_available(type, false)
	_update_play_status()


func _on_player_deselection(type):
	players_count -= 1
	for p in players:
		(p as PlayerIcon).set_type_available(type, true)
	_update_play_status()


func _update_play_status():
	print(players_count)
	can_play = (players_count >= 2)
	$PlayTooltip.visible = can_play


func start_game():
	var characters = []
	for p in players:
		characters.append((p.selected_type))
	
	emit_signal("game_start_requested", characters)
	hide()
