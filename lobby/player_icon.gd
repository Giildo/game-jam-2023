class_name PlayerIcon
extends VBoxContainer

export var ok_icon: Texture
export var back_icon: Texture

export var icon_join: Texture
export var icon_invalid: Texture
export var icon_select: Texture
export var icon_ready: Texture

var player_id = null
var is_assigned = false setget _set_assigned
var is_selected = false setget _set_selected
var selected_index = 0

var types = {
	Spawner.CharactersType.BUILDER: {'texture': preload("res://blocs/student/ball.png"), 'available': true},
	Spawner.CharactersType.DOCTOR: {'texture': preload("res://blocs/student/ruler.png"), 'available': true},
	Spawner.CharactersType.GAMER: {'texture': preload("res://blocs/translator/4.png"), 'available': true},
	Spawner.CharactersType.STUDENT: {'texture': preload("res://blocs/translator/d.png"), 'available': true},
	Spawner.CharactersType.TRANSLATOR: {'texture': preload("res://blocs/translator/m.png"), 'available': true},
}

signal type_selected(type)
signal type_deselected(type)


func _ready():
	_set_selected(false)
	_set_assigned(false)
	player_id = get_index() + 1


func _input(event: InputEvent):
	if event.is_pressed():
		if event.is_action("p%d_accept" % player_id):
			if is_assigned:
				_set_selected(true)
			else:
				_set_assigned(true)
		elif event.is_action("p%d_back" % player_id):
			if is_selected:
				_set_selected(false)
			else:
				_set_assigned(false)
		
		if is_assigned and not is_selected:
			if event.is_action("p%d_left" % player_id):
				selected_index = (selected_index - 1 + types.size()) % types.size()
				_update_type()
			elif event.is_action("p%d_right" % player_id):
				selected_index = (selected_index + 1) % types.size()
				_update_type()


func set_type_available(type, is_available):
	types[type].available = is_available


func _update_type():
	$HBoxContainer/Icon/Character.texture = types[selected_index].texture
	$HBoxContainer/Icon.texture = icon_select if types[selected_index].available else icon_invalid

func _set_assigned(value: bool):
	$HBoxContainer/Icon.texture = icon_select if value else icon_join
	$HBoxContainer/Icon/Character.visible = value
	$Tooltips/TooltipJoin/Buttons.texture = back_icon if value else ok_icon
	$Tooltips/TooltipJoin/Label.text = "leave" if value else "join"
	$Tooltips/TooltipSelect.visible = value
	is_assigned = value


func _set_selected(value: bool):
	$HBoxContainer/Icon.texture = icon_ready if value else icon_select
	$Tooltips/TooltipSelect/Buttons.texture = back_icon if value else ok_icon
	$Tooltips/TooltipSelect/Label.text = "de-select" if value else "select"
	$Tooltips/TooltipJoin.visible = not value
	is_selected = value
	
	if value:
		emit_signal("type_selected", selected_index)
	else:
		emit_signal("type_selected", selected_index)
