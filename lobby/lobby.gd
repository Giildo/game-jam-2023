extends Control

var players: Array = []

func _ready():
	players = $Players.get_children()
	for p in players:
		p.connect("type_selected", self, "_on_player_selection")
		p.connect("type_deselected", self, "_on_player_deselection")


func _on_player_selection(type):
	for p in players:
		(p as PlayerIcon).set_type_available(type, false)


func _on_player_deselection(type):
	for p in players:
		(p as PlayerIcon).set_type_available(type, true)
