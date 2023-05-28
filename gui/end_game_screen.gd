extends Control


signal menu_requested
signal restart_requested

func _input(event):
	if event is InputEventJoypadButton and event.is_pressed() and not event.is_echo():
		if event.button_index == JOY_START and visible:
			emit_signal("restart_requested")
		elif event.button_index == JOY_XBOX_B and visible:
			emit_signal("menu_requested")
			get_tree().get_root().set_input_as_handled()
