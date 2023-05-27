extends VBoxContainer


var player_id = null
var assigned = false setget _set_assigned


func _ready():
	player_id = get_index()

func _input(event: InputEvent):
	if event is InputEventJoypadButton and event.device == player_id:
		if event.button_index == JOY_SONY_X:
			_set_assigned(true)
		elif event.button_index == JOY_SONY_CIRCLE:
			_set_assigned(false)

func _set_assigned(value: bool):
	$HBoxContainer/Icon.texture = (
		preload("res://lobby/base_icon.png") if value else
		preload("res://lobby/add_button.png")
	)
	$Tooltip/Buttons.texture = (
		preload("res://lobby/b_o_buttons.png") if value else
		preload("res://lobby/x_a_buttons.png")
	)
	$Tooltip/Label.text =  (
		"to leave" if value else
		"to join"
	)
	
	
