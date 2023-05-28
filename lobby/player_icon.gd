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
var selected_type = 0

var types = {
	Spawner.CharactersType.BUILDER: {'texture': preload("res://lobby/icons/characters/Builder.png"), 'available': true},
	Spawner.CharactersType.DOCTOR: {'texture': preload("res://lobby/icons/characters/Doctor.png"), 'available': true},
	Spawner.CharactersType.GAMER: {'texture': preload("res://lobby/icons/characters/Gamer.png"), 'available': true},
	Spawner.CharactersType.STUDENT: {'texture': preload("res://lobby/icons/characters/Student.png"), 'available': true},
	Spawner.CharactersType.TRANSLATOR: {'texture': preload("res://lobby/icons/characters/Translator.png"), 'available': true},
}

signal type_selected(type)
signal type_deselected(type)


func _ready():
	_set_selected(false)
	_set_assigned(false)
	_update_type_icon()
	player_id = get_index() + 1


func _input(event: InputEvent):
	if event.is_pressed() and not event.is_echo():
		if event.is_action("p%d_accept" % player_id):
			if is_assigned:
				if types[selected_type].available:
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
				selected_type = (selected_type - 1 + types.size()) % types.size()
				$HBoxContainer/AnimationPlayer.root_node = $HBoxContainer/Left.get_path()
				_update_type()
			elif event.is_action("p%d_right" % player_id):
				selected_type = (selected_type + 1) % types.size()
				$HBoxContainer/AnimationPlayer.root_node = $HBoxContainer/Right.get_path()
				_update_type()


func set_type_available(type, is_available):
	types[type].available = is_available
	_update_type_icon()


func _update_type():
	$HBoxContainer/AnimationPlayer.play("Stretch")
	$HBoxContainer/Icon/Character/AnimationPlayer.play("Fade")


func _update_type_icon():
	$HBoxContainer/Icon/Character.texture = types[selected_type].texture
	$Tooltips/TooltipSelect.visible = true
	if is_assigned:
		if is_selected:
			$HBoxContainer/Icon.texture = icon_ready
		else:
			$HBoxContainer/Icon.texture = icon_select if types[selected_type].available else icon_invalid
			$HBoxContainer/Icon/Character.self_modulate = Color.white if types[selected_type].available else Color.gray
			$Tooltips/TooltipSelect.visible = types[selected_type].available

func _set_assigned(value: bool):
	$HBoxContainer/Icon.texture = icon_select if value else icon_join
	$HBoxContainer/Icon/Character.visible = value
	$Tooltips/TooltipJoin/Buttons.texture = back_icon if value else ok_icon
	$Tooltips/TooltipJoin/Label.text = "leave" if value else "join"
	$Tooltips/TooltipSelect.visible = value
	$HBoxContainer/Left.visible = value
	$HBoxContainer/Right.visible = value
	is_assigned = value
	_update_type_icon()

func _set_selected(value: bool):
	$HBoxContainer/Icon.texture = icon_ready if value else icon_select
	$Tooltips/TooltipSelect/Buttons.texture = back_icon if value else ok_icon
	$Tooltips/TooltipSelect/Label.text = "back" if value else "select"
	$Tooltips/TooltipJoin.visible = not value
	is_selected = value
	
	
	if value:
		$HBoxContainer/Icon/Character.self_modulate = Color.gray
		$HBoxContainer/Left.modulate = Color.gray
		$HBoxContainer/Right.modulate = Color.gray
		emit_signal("type_selected", selected_type)
	else:
		$HBoxContainer/Icon/Character.self_modulate = Color.white
		$HBoxContainer/Left.modulate = Color.white
		$HBoxContainer/Right.modulate = Color.white
		emit_signal("type_deselected", selected_type)
