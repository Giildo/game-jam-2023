class_name Controller
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bloc

#func _input(event):

# Called when the node enters the scene tree for the first time.
func _ready():
	bloc = get_node('Bloc')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass
