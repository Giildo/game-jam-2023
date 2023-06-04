class_name Lobby
extends Control

signal game_start_requested(characters)

var player_slots = []
var ready_players_count = 0
var can_play = false


func _input(event):
	if event is InputEventJoypadButton and event.is_pressed() and not event.is_echo():
		if event.button_index == JOY_START and can_play and visible:
			start_game()


func _ready():
	player_slots = $PlayerSlots.get_children()
	for p in player_slots:
		p.connect("class_selected", self, "_on_slot_class_selected")
		p.connect("class_deselected", self, "_on_slot_class_deselected")
	_update_play_status()


func reset_selection():
	for p in player_slots:
		if p.is_selected:
			p.is_selected = false


func start_game():
	var classes = []
	for p in player_slots:
		if p.is_selected():
			classes.append(p.selected_type)
	
	emit_signal("game_start_requested", classes)
	hide()


func _on_slot_class_selected(selection):
	ready_players_count += 1
	for p in player_slots:
		p.set_class_available(selection, false)
	_update_play_status()


func _on_slot_class_deselected(selection):
	ready_players_count -= 1
	for p in player_slots:
		p.set_class_available(selection, true)
	_update_play_status()


func _update_play_status():
	can_play = (ready_players_count >= 2)
	if can_play and not $PlayTooltip.visible:
		$PlayTooltip/AnimationPlayer.seek(0.0)
	
	$PlayTooltip.visible = can_play
