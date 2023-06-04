class_name PlayerSlot
extends VBoxContainer

signal class_selected(what)
signal class_deselected(what)

enum State {
	EMPTY,
	ASSIGNED,
	SELECTED,
}

export var empty_icon: Texture
export var assigned_icon: Texture
export var selected_icon: Texture
export var invalid_icon: Texture

var classes = [
	Spawner.CharactersType.BUILDER,
	Spawner.CharactersType.DOCTOR,
	Spawner.CharactersType.GAMER,
	Spawner.CharactersType.STUDENT,
	Spawner.CharactersType.TRANSLATOR,
]

var unavailable_classes = []

var textures = {
	Spawner.CharactersType.BUILDER: preload("res://lobby/icons/classes/builder.png"),
	Spawner.CharactersType.DOCTOR: preload("res://lobby/icons/classes/doctor.png"),
	Spawner.CharactersType.GAMER: preload("res://lobby/icons/classes/gamer.png"),
	Spawner.CharactersType.STUDENT: preload("res://lobby/icons/classes/student.png"),
	Spawner.CharactersType.TRANSLATOR: preload("res://lobby/icons/classes/translator.png"),
}

var _state = State.EMPTY
var _controller_id = null
var _selected_index = 0


func _ready():
	_controller_id = get_index() + 1
	_update_visuals()


func _input(event: InputEvent):
	if event.is_action_pressed("p{id}_accept".format({id = _controller_id})):
		match _state:
			State.EMPTY:
				_state = State.ASSIGNED
			State.ASSIGNED:
				if not classes[_selected_index] in unavailable_classes:
					_state = State.SELECTED
					emit_signal("class_selected", classes[_selected_index])
		_update_visuals()
		
	elif event.is_action_pressed("p{id}_back".format({id = _controller_id})):
		match _state:
			State.SELECTED:
				_state = State.ASSIGNED
				emit_signal("class_deselected", classes[_selected_index])
			State.ASSIGNED:
				_state = State.EMPTY
		_update_visuals()
		
	if _state == State.ASSIGNED:
		if event.is_action_pressed("p{id}_left".format({id = _controller_id})):
			_selected_index = (_selected_index - 1 + classes.size()) % classes.size()
			
			$Content/AnimationPlayer.root_node = $Content/LeftArrow.get_path()
			$Content/AnimationPlayer.play("Stretch")
			$Content/Slot/Icon/AnimationPlayer.stop()
			$Content/Slot/Icon/AnimationPlayer.play("Fade")
			
		elif event.is_action_pressed("p{id}_right".format({id = _controller_id})):
			_selected_index = (_selected_index + 1) % classes.size()
			
			$Content/AnimationPlayer.root_node = $Content/RightArrow.get_path()
			$Content/AnimationPlayer.play("Stretch")
			$Content/Slot/Icon/AnimationPlayer.stop()
			$Content/Slot/Icon/AnimationPlayer.play("Fade")


func get_class():
	return classes[_selected_index]


func is_selected():
	return _state == State.SELECTED


func set_class_available(which, is_available):
	if not is_available:
		unavailable_classes.append(which)
	else:
		unavailable_classes.erase(which)
	_update_visuals()


func _update_visuals():
	$Content/Slot/Icon.texture = textures.get(classes[_selected_index])

	$Content/Slot/Icon.visible = _state != State.EMPTY
	$Content/LeftArrow.visible = _state != State.EMPTY
	$Content/RightArrow.visible = _state != State.EMPTY
	$Tooltips/BackTooltip.visible = _state != State.EMPTY
	$Tooltips/AcceptTooltip.visible = _state != State.SELECTED
	
	match _state:
		State.EMPTY:
			$Content/Slot.texture = empty_icon
			
			$Tooltips/AcceptTooltip/Label.text = "join"
		
		State.ASSIGNED:
			if get_class() in unavailable_classes:
				$Content/Slot.texture = invalid_icon
			else:
				$Content/Slot.texture = assigned_icon
			
			$Tooltips/AcceptTooltip/Label.text = "select"
			$Tooltips/BackTooltip/Label.text = "leave"
			
			$Content/LeftArrow.modulate = Color.white
			$Content/RightArrow.modulate = Color.white
		
		State.SELECTED:
			$Content/Slot.texture = selected_icon
			
			$Tooltips/BackTooltip/Label.text = "back"
			
			$Content/LeftArrow.modulate = Color.gray
			$Content/RightArrow.modulate = Color.gray
			
