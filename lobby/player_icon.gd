extends VBoxContainer


var player_id = null
var is_assigned = false setget _set_assigned
var is_selected = false setget _set_selected


func _ready():
	_set_assigned(false)
	_set_selected(false)
	player_id = get_index()

func _input(event: InputEvent):
	if (event is InputEventJoypadButton and  not event.is_echo()
		and event.is_pressed() and event.device == player_id):

		
		if event.button_index == JOY_SONY_X:
			if is_assigned:
				_set_selected(true)
			else:
				_set_assigned(true)
		elif event.button_index == JOY_SONY_CIRCLE:
			if is_selected:
				_set_selected(false)
			else:
				_set_assigned(false)
			

func _set_assigned(value: bool):
	$HBoxContainer/Icon.texture = (
		preload("res://lobby/base_icon.png") if value else
		preload("res://lobby/add_button.png")
	)
	$Tooltips/TooltipJoin/Buttons.texture = (
		preload("res://lobby/b_o_buttons.png") if value else
		preload("res://lobby/x_a_buttons.png")
	)

	$Tooltips/TooltipJoin/Label.text = (
		"leave" if value else "join"
	)
	$Tooltips/TooltipSelect.visible = value
	is_assigned = value


func _set_selected(value: bool):
	
	$Tooltips/TooltipSelect/Buttons.texture = (
		preload("res://lobby/b_o_buttons.png") if value else
		preload("res://lobby/x_a_buttons.png")
	)
	
	$Tooltips/TooltipSelect/Label.text = (
		"de-select" if value else "select"
	)
	
	$Tooltips/TooltipJoin.visible = not value
	
	is_selected = value
