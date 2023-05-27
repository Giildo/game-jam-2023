extends Node


# Declare member variables here. Examples:
var spawners: Array

func start_game(characters: Array) -> void:
	for i in range(characters.size()):
		var spawner = Spawner.new(characters[i], characters.size(), i)
		spawners.append(spawner)
		add_child(spawner)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game([Spawner.CharactersType.STUDENT])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
