extends VBoxContainer


var player_id = null
var is_assigned = false setget _set_assigned
var is_selected = false setget _set_selected


export var ok_icon: Texture
export var back_icon: Texture

export var icon_join: Texture 
export var icon_invalid: Texture 
export var icon_select: Texture 
export var icon_ready: Texture 


func _ready():
	_set_selected(false)
	_set_assigned(false)
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
	$HBoxContainer/Icon.texture = icon_select if value else icon_join
	$Tooltips/TooltipJoin/Buttons.texture = back_icon if value else ok_icon

	$Tooltips/TooltipJoin/Label.text = (
		"leave" if value else "join"
	)
	$Tooltips/TooltipSelect.visible = value
	is_assigned = value


func _set_selected(value: bool):
	$HBoxContainer/Icon.texture = icon_ready if value else icon_select
	$Tooltips/TooltipSelect/Buttons.texture = back_icon if value else ok_icon
	
	$Tooltips/TooltipSelect/Label.text = (
		"de-select" if value else "select"
	)
	
	$Tooltips/TooltipJoin.visible = not value
	
	is_selected = value
